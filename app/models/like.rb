# frozen_string_literal: true

class Like < ApplicationRecord
  belongs_to :user
  belongs_to :diary

  validates :user_id, uniqueness: { scope: :diary_id }

  def self.likes_count(diary_ids)
    Like.where(diary_id: diary_ids)
        .group(:diary_id)
        .sum(:count)
  end
end
