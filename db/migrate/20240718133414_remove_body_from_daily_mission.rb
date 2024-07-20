# frozen_string_literal: true

class RemoveBodyFromDailyMission < ActiveRecord::Migration[7.1]
  def change
    remove_column :daily_missions, :body, :text
  end
end
