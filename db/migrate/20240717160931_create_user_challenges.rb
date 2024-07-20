# frozen_string_literal: true

class CreateUserChallenges < ActiveRecord::Migration[7.1]
  def change
    create_table :user_challenges do |t|
      t.boolean :status, default: false
      t.references :user, foreign_key: true
      t.references :challenge_mission, foreign_key: true
      t.timestamps
    end
  end
end
