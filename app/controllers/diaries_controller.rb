# frozen_string_literal: true

class DiariesController < ApplicationController
  before_action :authenticate_user!, only: %i[new create edit update destroy]
  def index
    @q = Diary.ransack(params[:q])
    @diaries = @q.result.includes(:user).with_likes_count.order(diary_date: :desc)
  end

  def new
    @diary = Diary.new
  end

  def create
    @diary = current_user.diaries.build(diary_params)
    logger.debug "message::::current_user.reward result #{result}"
    if @diary.save
      result = DailyMission.update_mission(user: current_user, mission_title: '日記を投稿する')
      if result[:process]
        flash[:daily_missions_update] =
          t('defaults.flash_message.daily_missions_updated', item: result[:message])
      end
      redirect_to diaries_path, success: t('defaults.flash_message.created', item: t('activerecord.models.diary'))
    else
      flash.now[:danger] = t('defaults.flash_message.not_created', item: t('activerecord.models.diary'))
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @diary = Diary.with_likes_count.find(params[:id])
    @comment = Comment.new
    @comments = @diary.comments.includes(:user).order(created_at: :asc)
  end

  def edit
    @diary = current_user.diaries.find(params[:id])
  end

  def update
    @diary = current_user.diaries.find(params[:id])
    if @diary.update(diary_params)
      redirect_to diaries_path, success: t('defaults.flash_message.updated', item: t('activerecord.models.diary'))
    else
      flash.now[:danger] = t('defaults.flash_message.not_updated', item: t('activerecord.models.diary'))
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    diary = current_user.diaries.find(params[:id])
    diary.destroy!
    redirect_to diaries_path, success: t('defaults.flash_message.deleted', item: t('activerecord.models.diary'))
  end

  def search
    @diaries = Diary.where("title LIKE ?", "%#{params[:q]}%")
    respond_to do |format|
      format.js
    end
  end

  private

  def diary_params
    params.require(:diary).permit(:title, :body, :diary_date, :diary_image, :diary_image_cache)
  end
end
