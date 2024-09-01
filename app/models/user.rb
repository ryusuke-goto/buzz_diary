# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[line] # for line-login

  has_many :diaries, dependent: :destroy
  has_one :buff, dependent: :destroy
  has_one :reward, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :like_diaries, through: :likes, source: :diary
  has_many :user_dailies, dependent: :destroy
  has_many :user_challenges, dependent: :destroy
  has_many :my_dailies, through: :user_dailies, source: :daily_mission
  has_many :my_challenges, through: :user_challenges, source: :challenge_mission

  after_create :create_buff, :create_reward
  after_commit :ensure_buff_exists, :ensure_reward_exists, on: :create

  # for line-login
  def social_profile(provider)
    social_profiles.select { |sp| sp.provider == provider.to_s }.first
  end

  def set_values(omniauth)
    return if provider.to_s != omniauth['provider'].to_s || uid != omniauth['uid']

    credentials = omniauth['credentials']
    info = omniauth['info']

    credentials['refresh_token']
    credentials['secret']
    credentials.to_json
    info['name']
    info['image']
    # self.set_values_by_raw_info(omniauth['extra']['raw_info'])
  end

  def set_values_by_raw_info(raw_info)
    puts "[event]#{raw_info.to_json}"
    self.raw_info = raw_info.to_json
    save!
  end

  def create_buff
    create_buff!
  end

  def ensure_buff_exists
    buff || create_buff!
  end

  def create_reward
    create_reward!
  end

  def ensure_reward_exists
    reward || create_reward!
  end

  def own?(object)
    object.user_id == id
  end

  def number_of_consecutive_days
    past_count = 0
    my_diaries = diaries.order(created_at: :desc)
    my_diaries.each do |diary|
      if diary.created_at.between?((Time.zone.today - past_count).beginning_of_day, (Time.zone.today - past_count).end_of_day)
        past_count += 1
      else
        break
      end
    end
    milestones = {
      30 => '30日間連続で投稿する',
      21 => '21日間連続で投稿する',
      14 => '14日間連続で投稿する',
      7 => '7日間連続で投稿する',
      3 => '3日間連続で投稿する'
    }

    logger.debug "message::::past_count: #{past_count}"
    self.mission_milestones_check(milestones, past_count)
  end

  def like(diary)
    like = Like.find_or_create_by!(user_id: id, diary_id: diary.id)
    like.count += diary.user.buff.sum_buff
    like.save!
  end

  def number_of_liked_diaries
    milestones = {
      10 => '10個の日記にいいね',
      50 => '50個の日記にいいね',
      100 => '100個の日記にいいね',
      150 => '150個の日記にいいね'
    }
  
    counts = likes.count
    logger.debug "message::::likes_count: #{counts}"
    self.mission_milestones_check(milestones, counts)
  end

  def number_of_comments
    milestones = {
      5 => '5個のコメントを投稿',
      10 => '10個のコメントを投稿',
      15 => '15個のコメントを投稿',
      20 => '20個のコメントを投稿'
    }
  
    counts = comments.count
    logger.debug "message::::comments_count: #{counts}"
    self.mission_milestones_check(milestones, counts)
  end

  def mission_milestones_check(milestones, count)
    milestones.each do |threshold, mission_title|
      if count > threshold
        result = ChallengeMission.update_mission(user: self, mission_title: mission_title)
        if result
          logger.debug "message::::mission updated for milestone #{threshold}"
          return { process: true, message: mission_title }
        else
          logger.debug "message::::mission not update for milestone #{threshold}"
        end
      end
    end
    { process: false }
  end

  def add_buff(daily: 0, challenge: 0, mission: nil)
    logger.debug 'message::::add_buff executed'
    logger.debug "self: #{self}"
    logger.debug "self.buff: #{buff}"
  
    updated = false
  
    if daily.positive?
      update_buff(:daily_buff, daily)
      updated = true
    end
  
    if challenge.positive?
      update_buff(:challenge_buff, challenge)
      updated = true
      update_css(mission)
    end
  
    unless updated
      logger.debug 'error::::cannot add buff'
      return false
    end
  
    true
  end

  def update_css(mission)
    logger.debug 'message::::update_reward executed'
    logger.debug "message::::mission is #{mission.inspect}"

    if mission.like_css.present?
      increment!(:like_css, mission.like_css)
      logger.debug 'message::::like_css update'
    elsif mission.diary_css.present?
      increment!(:diary_css, mission.diary_css)
      logger.debug 'message::::diary_css update'
    elsif mission.theme_css.present?
      increment!(:theme_css, mission.theme_css)
      logger.debug 'message::::theme_css update'
    end
  end

  def self.ransackable_attributes(_auth_object = nil)
    ['name']
  end

  def update_buff(type, amount)
    buff.increment!(type, amount)
    buff.increment!(:sum_buff, amount)
    logger.debug "message::::#{type} updated to #{buff[type]}"
  end
end
