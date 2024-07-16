# frozen_string_literal: true

class Diary < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  validates :title, presence: true, length: { maximum: 255 }
  validates :body, presence: true, length: { maximum: 65_535 }
  validates :diary_date, presence: true, uniqueness: { scope: :user_id }

  mount_uploader :diary_image, DiaryImageUploader

  def start_time
    self.diary_date ##Where 'start' is a attribute of type 'Date' accessible through MyModel's relationship
  end
end
