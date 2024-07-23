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

  def self.check_count_like_record(user)
    mission = self.find_by("title LIKE?", "%10個の日記にいいね%")
    user_challenge = user.user_challenges.find_by(challenge_mission_id: mission.id)
    if !user_challenge.status
      logger.debug "user_challenge.update executed"
      user_challenge.update(status: true)
      user.add_challenge_buff(mission.buff)
  end
end
