class UserChallenge < ApplicationRecord
  belongs_to :user
  belongs_to :challenge_mission
end
