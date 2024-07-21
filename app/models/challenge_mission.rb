# frozen_string_literal: true

class ChallengeMission < ApplicationRecord
  has_many :user_challenges, dependent: :destroy

  validates :title, presence: true, length: { maximum: 255 }
  validates :description, presence: true, length: { maximum: 65_535 }

  def self.check_record_user_challenges(user_id)
    challenge_mission_ids = ChallengeMission.pluck(:id)
    existing_challenge_mission_ids = UserChallenge.where(user_id: user_id, challenge_mission_id: challenge_mission_ids).pluck(:challenge_mission_id)

    missing_challenge_mission_ids = challenge_mission_ids - existing_challenge_mission_ids

    missing_challenge_mission_ids.each do |challenge_mission_id|
      UserChallenge.create(user_id: user_id, challenge_mission_id: challenge_mission_id)
    end
  end
end
