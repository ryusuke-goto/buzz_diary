# frozen_string_literal: true

class AddDefaultValueToMissions < ActiveRecord::Migration[7.1]
  def change
    change_column_default :daily_missions, :description, from: nil, to: 'ミッションの説明'
    change_column_default :challenge_missions, :description, from: nil, to: 'ミッションの説明'
  end
end
