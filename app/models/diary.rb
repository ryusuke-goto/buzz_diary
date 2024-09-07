# frozen_string_literal: true

class Diary < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  validates :title, presence: true, length: { maximum: 255 }
  validates :body, presence: true, length: { maximum: 65_535 }
  validates :diary_date, presence: true, uniqueness: { scope: :user_id }

  mount_uploader :diary_image, DiaryImageUploader

  # likes_countを一緒に取得するスコープ
  scope :with_likes_count, lambda {
    left_joins(:likes)
      .select('diaries.*, COALESCE(SUM(likes.count), 0) AS likes_count')
      .group('diaries.id')
  }

  def start_time
    diary_date # #Where 'start' is a attribute of type 'Date' accessible through MyModel's relationship
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[body created_at diary_date title]
  end

  def self.ransackable_associations(_auth_object = nil)
    ['user']
  end
end
