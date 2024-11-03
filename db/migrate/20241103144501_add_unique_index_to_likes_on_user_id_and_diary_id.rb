# frozen_string_literal: true

class AddUniqueIndexToLikesOnUserIdAndDiaryId < ActiveRecord::Migration[7.1]
  def change
    add_index :likes, %i[diary_id user_id], unique: true
  end
end
