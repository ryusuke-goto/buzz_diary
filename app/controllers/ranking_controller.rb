class RankingController < ApplicationController
  def index
    max_liked_diaries
    max_liked_users
  end

  private

  def max_liked_diaries
    diaries = Diary.includes(:user).with_likes_count.order(diary_date: :desc).to_a
    max_likes_count = diaries.map(&:likes_count).max
    @max_liked_diaries = diaries.select { |diary| diary.likes_count == max_likes_count }
  end

  def max_liked_users
    # ユーザーごとの「いいねした日記」数を集計
    user_likes_record_count = Like.group(:user_id).count
    # 最大「いいねした日記」数を取得
    max_likes_count = user_likes_record_count.values.max   
    # 最大「いいねした日記」数を持つユーザーIDを取得
    max_likes_user_ids = user_likes_record_count.select { |_, v| v == max_likes_count }.keys    
    logger.debug "message::::max_likes_user_ids #{max_likes_user_ids}"
    # 最大「いいねした日記」数を持つユーザーの情報を取得
    @max_likes_record_users = User.where(id: max_likes_user_ids).select(:name, :image)
  end
end
