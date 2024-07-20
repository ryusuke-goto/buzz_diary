# frozen_string_literal: true

class UserDaily < ApplicationRecord
  belongs_to :user
  belongs_to :daily_mission
end
