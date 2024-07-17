# frozen_string_literal: true

class LikesController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  def create
    @diary = Diary.find_by(id: params[:diary_id])
    current_user.like(@diary)
  end

  def everything
    @today_diaries = Diary.where(diary_date: Date.today).includes(:user)
    @diaries = Diary.includes(:user).order(diary_date: :desc)
    if @today_diaries.present?
      @today_diaries.each do |diary|
        puts "diaryの値は#{diary}"
        current_user.like(diary)
      end
      redirect_to diaries_path, success: t('likes.everything_success')
    else
      redirect_to diaries_path, success: t('likes.everything_failed')
    end
  end
end
