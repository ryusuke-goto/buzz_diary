# frozen_string_literal: true

class LikesController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  def create
    diary = Diary.with_likes_count.find_by(id: params[:diary_id])
    current_user.like(diary)
    @diary = Diary.with_likes_count.find_by(id: params[:diary_id])
    result = current_user.number_of_liked_diaries
    return unless result[:process]

    logger.debug 'like_count update'
    flash[:challenge_missions_update] = t('defaults.flash_message.challenge_missions_updated', item: result[:message])
  end

  def everything
    @today_diaries = Diary.where(diary_date: Time.zone.today).includes(:user)
    @diaries = Diary.includes(:user).with_likes_count.order(diary_date: :desc)
    if @today_diaries.present?
      @today_diaries.each do |diary|
        current_user.like(diary)
      end
      current_user.number_of_liked_diaries
      @diaries.pluck(:id)
      redirect_to diaries_path, success: t('likes.everything_success')
    else
      redirect_to diaries_path, success: t('likes.everything_failed')
    end
  end
end
