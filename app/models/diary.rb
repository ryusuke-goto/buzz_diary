# frozen_string_literal: true

class Diary < ApplicationRecord
  belongs_to :user

  validates :title, presence: true, length: { maximum: 255 }
  validates :body, presence: true, length: { maximum: 65_535 }
  validates :diary_date, presence: true, uniqueness: true

  mount_uploader :diary_image, DiaryImageUploader
end
