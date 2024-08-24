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

  def like(diary)
    like = Like.find_or_create_by!(user_id: id, diary_id: diary.id)
    like.count += diary.user.buff.sum_buff
    like.save!
  end

  def liked_diary_count
    counts = likes.count
    if counts > 10
      result = ChallengeMission.update_mission(user: self, mission_title: '10個の日記にいいね')
      if result
        { success: true, message: '10個の日記にいいね' }
      else
        logger.debug 'message::::like_count_mission not update'
        { success: false }
      end
    else
      logger.debug 'message::::like_count_mission not update'
      { success: false }
    end
  end

  def add_buff(daily: 0, challenge: 0, mission: nil)
    logger.debug 'message::::add_buff executed'
    logger.debug "self: #{self}"
    logger.debug "self.buff: #{buff}"
    if daily.positive?
      self.buff.daily_buff += daily
      logger.debug "message::::daily_buff: #{buff.daily_buff}"
      self.buff.save!
      self.buff.sum_buff += buff.daily_buff
      self.save!
      true
    elsif challenge.positive?
      buff.challenge_buff += challenge
      logger.debug "message::::challenge_buff: #{buff.challenge_buff}"
      self.buff.save!
      self.buff.sum_buff += buff.challenge_buff
      self.save!
      result = self.update_reward(mission)
      logger.debug "message::::update_reward result #{self.like_css}"
      true
    else
      logger.debug 'error::::cannot add buff'
      false
    end
  end

  def update_reward(mission)
    logger.debug 'message::::update_reward executed'
    logger.debug "message::::mission is #{mission.inspect}"
    logger.debug "self: #{self}"
    logger.debug "self.like_css: #{like_css}"
    if mission.like_css.present?
      self.like_css += mission.like_css
      self.save!
      logger.debug 'message::::like_css update'
    elsif mission.diary_css.present?
      diary_css += mission.diary_css
      logger.debug 'message::::diary_css update'
    elsif mission.theme_css.present?
      theme_css += mission.theme_css
      logger.debug 'message::::theme_css update'
    end
  end

  def self.ransackable_attributes(_auth_object = nil)
    ['name']
  end
end
