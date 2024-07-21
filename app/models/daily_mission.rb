# frozen_string_literal: true

class DailyMission < ApplicationRecord
  has_many :user_dailies, dependent: :destroy

  validates :title, presence: true, length: { maximum: 255 }
  validates :description, presence: true, length: { maximum: 65_535 }

  def self.check_record_user_dailies(user_id)
    daily_mission_ids = self.pluck(:id)
    existing_daily_mission_ids = UserDaily.where(user_id: user_id, daily_mission_id: daily_mission_ids).pluck(:daily_mission_id)

    missing_daily_mission_ids = daily_mission_ids - existing_daily_mission_ids

    missing_daily_mission_ids.each do |daily_mission_id|
      UserDaily.create(user_id: user_id, daily_mission_id: daily_mission_id)
    end
  end

  def self.check_create_diary_today_mission(user)
    logger.debug "check_create_diary_mission executed"
    mission = self.find_by("title LIKE?", "%日記を投稿する%")
    user_daily = user.user_dailies.find_by(daily_mission_id: mission.id)
    today_diary = user.diaries.find_by(created_at: Date.today.beginning_of_day..Date.today.end_of_day)
    if today_diary.present?
      logger.debug "user_daily.update executed"
      @daily_mission_update = user_daily.update(status: true)
      user.add_daily_buff(mission.buff)
    end
  end
end