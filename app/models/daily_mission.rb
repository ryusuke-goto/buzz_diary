# frozen_string_literal: true

class DailyMission < ApplicationRecord
  has_many :user_dailies, dependent: :destroy

  validates :title, presence: true, length: { maximum: 255 }
  validates :description, presence: true, length: { maximum: 65_535 }

  def self.check_record_user_dailies(user_id)
    daily_mission_ids = DailyMission.pluck(:id)
    existing_daily_mission_ids = UserDaily.where(user_id: user_id, daily_mission_id: daily_mission_ids).pluck(:daily_mission_id)

    missing_daily_mission_ids = daily_mission_ids - existing_daily_mission_ids

    missing_daily_mission_ids.each do |daily_mission_id|
      UserDaily.create(user_id: user_id, daily_mission_id: daily_mission_id)
    end
  end
end