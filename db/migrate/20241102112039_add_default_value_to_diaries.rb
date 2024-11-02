# frozen_string_literal: true

class AddDefaultValueToDiaries < ActiveRecord::Migration[7.1]
  def change
    change_column_default :diaries, :diary_date, from: nil, to: -> { 'CURRENT_DATE' }
  end
end
