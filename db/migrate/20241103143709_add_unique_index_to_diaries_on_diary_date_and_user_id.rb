# frozen_string_literal: true

class AddUniqueIndexToDiariesOnDiaryDateAndUserId < ActiveRecord::Migration[7.1]
  def change
    add_index :diaries, %i[diary_date user_id], unique: true
  end
end
