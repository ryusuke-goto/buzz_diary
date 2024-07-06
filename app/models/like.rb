class Like < ApplicationRecord
  belongs_to :user
  belongs_to :diary

  validates :user_id, uniqueness: { scope: :diary_id }

  def self.likes_count(id)
    likes = Like.where(diary_id: id)
    total_count = likes.map(&:count).sum
  end
end
