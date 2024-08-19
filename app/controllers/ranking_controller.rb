class RankingController < ApplicationController
  def index
    diaries = Diary.includes(:user).with_likes_count.order(diary_date: :desc).to_a
    max_likes_count = diaries.map(&:likes_count).max
    @max_liked_diaries = diaries.select { |diary| diary.likes_count == max_likes_count }
  end
end
