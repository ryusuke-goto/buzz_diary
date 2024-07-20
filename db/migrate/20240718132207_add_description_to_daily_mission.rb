# frozen_string_literal: true

class AddDescriptionToDailyMission < ActiveRecord::Migration[7.1]
  def change
    add_column :daily_missions, :description, :text, null: false
  end
end
