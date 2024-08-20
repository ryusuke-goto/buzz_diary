class RankingController < ApplicationController
  def index
    diaries = Diary.includes(:user).with_likes_count.order(diary_date: :desc).to_a
    max_likes_count = diaries.map(&:likes_count).max
    @max_liked_diaries = diaries.select { |diary| diary.likes_count == max_likes_count }
    user_likes_record_count = Like.includes(:user).group(:user_id).count
    max_likes_record = user_likes_record_count.max
    max_likes_record_users = User.where(id: max_likes_record.user_id).select(:name, :image)
  end
end
