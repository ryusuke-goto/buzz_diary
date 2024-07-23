# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[line] # for line-login

  has_many :diaries, dependent: :destroy
  has_one :buff, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :like_diaries, through: :likes, source: :diary
  has_many :user_dailies, dependent: :destroy
  has_many :user_challenges, dependent: :destroy
  has_many :my_dailies, through: :user_dailies, source: :daily_mission
  has_many :my_challenges, through: :user_challenges, source: :challenge_mission

  after_create :create_buff
  after_commit :ensure_buff_exists, on: :create

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
    # self.set_values_by_raw_info(omniauth['extra']['raw_info'])
  end

  def set_values_by_raw_info(raw_info)
    self.raw_info = raw_info.to_json
    save!
  end

  def create_buff
    self.create_buff!
  end

  def ensure_buff_exists
    self.buff || self.create_buff!
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
    self.like_diary.where(created_at: Date.today.beginning_of_day..Date.today.end_of_day)
  end

  def add_daily_buff(target_buff)
    logger.debug "add_daily_buff executed"
    current_buff = self.buff
    current_buff.daily_buff += target_buff
    current_buff.save!
    self.sum_buff
  end

  def sum_buff
    logger.debug "add_daily_buff executed"
    current_buff = self.buff
    current_buff.sum_buff += current_buff.daily_buff + current_buff.challenge_buff
    current_buff.save!
  end
end
