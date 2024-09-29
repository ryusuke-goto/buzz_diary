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

  def consecutive_days
    past_count = 0
    consecutive_count = 0
    my_diaries = diaries.order(created_at: :desc)
    my_diaries.each do |diary|
      logger.info "message::diary: #{diary.inspect}"
      if diary.created_at.between?((Time.zone.today - past_count.day).beginning_of_day,
                                   (Time.zone.today - past_count.day).end_of_day)
# created_at.to_dateとdiary_dateが一致している日記なら連続投稿記録カウントを進める
        if diary.created_at.to_date == diary.diary_date
          past_count += 1
          consecutive_count += 1
          logger.info "message:: count up #{consecutive_count}"
          logger.info "message:: count up past #{past_count}"
        else
          logger.info 'message:: but different diary_date...not count up'
        end
# 最後にカウントアップ処理をしたレコードと同じcreated_at.to_dateかどうか検証。
# 同じcreated_at.to_dateのレコードの中から、diary_dateが一致するものを探すため。
      elsif diary.created_at.between?((Time.zone.today - (past_count - 1).day).beginning_of_day,
                                      (Time.zone.today - (past_count - 1).day).end_of_day) && diary.created_at.to_date != diary.diary_date
        logger.info 'message:: Same created_at as the previous record'
        if diary.created_at.to_date == diary.diary_date
          consecutive_count += 1
          logger.info "message:: count up #{consecutive_count}"
          logger.info "message:: count up past #{past_count}"
        else
          logger.info 'message:: but different diary_date...not count up & past_count'
        end
# 1日空いた後に日記があるかを確認。カウントが進むことを許容する。
      elsif diary.created_at.between?((Time.zone.today - (past_count + 1).day).beginning_of_day,
                                      (Time.zone.today - (past_count + 1).day).end_of_day)
        logger.info 'message::A diary existed with 1 day skipping.. OK'
        if diary.created_at.to_date == diary.diary_date
          past_count += 2
          consecutive_count += 1
          logger.info "message:: count up #{consecutive_count}"
          logger.info "message:: count up past #{past_count}"
        else
          logger.info 'message:: but different diary_date...not count up'
        end
# 2日空いた後に日記があるかを確認。カウントが進むことを許容する。
      elsif diary.created_at.between?((Time.zone.today - (past_count + 2).day).beginning_of_day,
                                      (Time.zone.today - (past_count + 2).day).end_of_day) && diary.created_at.to_date == diary.diary_date
        logger.info 'message::A diary existed with 2 day skipping. OK'
        if diary.created_at.to_date == diary.diary_date
          past_count += 3
          consecutive_count += 1
          logger.info "message:: count up #{consecutive_count}"
          logger.info "message:: count up past #{past_count}"
        else
          logger.info 'message:: but different diary_date...not count up'
        end
      else
        logger.info 'message::each loop break'
        break
      end
    end
    logger.info "message::::past_count: #{past_count}"
    logger.info "message::::consecutive_count: #{consecutive_count}"
    consecutive_count
  end

  def number_of_consecutive_days(consecutive_count)
    milestones = {
      30 => '30日間連続で日記を投稿',
      21 => '21日間連続で日記を投稿',
      14 => '14日間連続で日記を投稿',
      7 => '7日間連続で日記を投稿',
      3 => '3日間連続で日記を投稿'
    }
    mission_milestones_check(milestones, consecutive_count)
  end

  def like(diary)
    like = Like.find_or_create_by!(user_id: id, diary_id: diary.id)
    like.count += diary.user.buff.sum_buff
    like.save!
  end

  def number_of_liked_diaries
    milestones = {
      200 => '200個の日記にいいね',
      150 => '150個の日記にいいね',
      100 => '100個の日記にいいね',
      50 => '50個の日記にいいね',
      10 => '10個の日記にいいね'
    }

    counts = likes.count
    logger.debug "message::::likes_count: #{counts}"
    mission_milestones_check(milestones, counts)
  end

  def number_of_comments
    milestones = {
      40 => '40個のコメントを投稿',
      30 => '30個のコメントを投稿',
      20 => '20個のコメントを投稿',
      10 => '10個のコメントを投稿',
      5 => '5個のコメントを投稿'
    }

    counts = comments.count
    logger.debug "message::::comments_count: #{counts}"
    mission_milestones_check(milestones, counts)
  end

  def mission_milestones_check(milestones, count)
    milestones.each do |threshold, mission_title|
      next unless count >= threshold

      result = ChallengeMission.update_mission(user: self, mission_title:)
      if result
        logger.info "message::::mission updated for milestone #{threshold}"
        return { process: true, message: mission_title }
      else
        logger.info "message::::mission not update for milestone #{threshold}"
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
      update!(like_css: mission.like_css)
      logger.debug 'message::::like_css update'
    elsif mission.diary_css.present?
      update!(diary_css: mission.diary_css)
      logger.debug 'message::::diary_css update'
    elsif mission.theme_css.present?
      update!(theme_css: mission.theme_css)
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

  def get_friendship_status
    return unless access_token # access_tokenがなければリクエストを送らない

    uri = URI.parse('https://api.line.me/friendship/v1/status')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = uri.scheme === 'https'
    Net::HTTP::Get.new(uri)
    headers = { 'Authorization' => "Bearer #{access_token}" }
    response = http.get(uri.path, headers)
    # logger.info "message::::access_token: #{access_token}"
    response.code # status code
    response.body # response body
    logger.info "message::::response.code: #{response.code}"
    logger.info "message::::response.body: #{response.body}"

    friendFlag = JSON.parse(response.body)
    friendFlag['friendFlag']
  rescue StandardError => e
    Rails.logger.error "Failed to get friendship status: #{e.message}"
    nil
  end
end
