# frozen_string_literal: true

class ChallengeMission < ApplicationRecord
  has_many :user_challenges, dependent: :destroy

  validates :title, presence: true, length: { maximum: 255 }
  validates :description, presence: true, length: { maximum: 65_535 }

  def self.check_record_user_challenges(user_id)
    challenge_mission_ids = ChallengeMission.pluck(:id)
    existing_challenge_mission_ids = UserChallenge.where(user_id:,
                                                         challenge_mission_id: challenge_mission_ids).pluck(:challenge_mission_id)

    missing_challenge_mission_ids = challenge_mission_ids - existing_challenge_mission_ids

    missing_challenge_mission_ids.each do |challenge_mission_id|
      UserChallenge.create(user_id:, challenge_mission_id:)
    end
  end

  def self.update_mission(user:, mission_title:)
    mission = find_by('title LIKE ?', "%#{mission_title}%")
    logger.debug "message::::mission #{mission}"
    return false unless mission

    user_challenge = user.user_challenges.find_by(challenge_mission_id: mission.id)
    logger.debug "message::::user_challenge #{user_challenge.inspect}"
    if user_challenge.present? && !user_challenge.status
      logger.debug 'message::::user_challenge.update executed'
      user_challenge.update(status: true)
      result = user.add_buff(challenge: mission.buff, mission:)
      logger.debug "message::::add_buff result #{result}"
      if result
        logger.debug 'message::::add_buff success'
        true
      else
        logger.debug 'error::::add_buff failed'
        false
      end
    else
      logger.debug 'message::::mission not found or user_challenge_status is already true'
      false
    end
  end
end
