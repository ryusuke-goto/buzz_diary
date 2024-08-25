class RankingController < ApplicationController
  def index
    max_liked_diaries
    likes_record_users
  end

  private

  def max_liked_diaries
    diaries = Diary.includes(:user).with_likes_count.order(diary_date: :desc).to_a
    max_likes_count = diaries.map(&:likes_count).max
    @max_liked_diaries = diaries.select { |diary| diary.likes_count == max_likes_count }
  end

  def likes_record_users
    user_likes_record_count = Like.includes(:user).group(:user_id).count
    max_likes_record = user_likes_record_count.max
    logger.debug "message::::max_likes_record #{max_likes_record}"
    @max_likes_record_users = User.where(id: max_likes_record).select(:name, :image)
  end

end
