# frozen_string_literal: true

class DiariesController < ApplicationController
  before_action :authenticate_user!, only: %i[new create edit update destroy]
  before_action :set_diary, only: %i[show edit update destroy]
  before_action :verify_access, only: %i[edit update destroy]
  def index
    @q = Diary.ransack(params[:q])
    @diaries = @q.result.includes(:user).with_likes_count.order(created_at: :desc)
  end

  def new
    @diary = Diary.new
  end

  def create
    @diary = current_user.diaries.build(diary_params)
    if @diary.save
      daily_create_mission_check
      number_of_consecutive_days_check
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

  def edit; end

  def update
    if @diary.update(diary_params)
      redirect_to diary_path(@diary.id), success: t('defaults.flash_message.updated', item: t('activerecord.models.diary'))
    else
      flash.now[:danger] = t('defaults.flash_message.not_updated', item: t('activerecord.models.diary'))
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @diary.destroy!
    redirect_to diaries_path, success: t('defaults.flash_message.deleted', item: t('activerecord.models.diary'))
  end

  def search
    @diaries = Diary.where('title LIKE ?', "%#{params[:q]}%")
    respond_to(&:js)
  end

  private

  def set_diary
    @diary = Diary.find(params[:id])
  end

  def verify_access
    redirect_to root_url, alert: 'Forbidden access.' unless current_user.my_object?(@diary)
  end

  def diary_params
    params.require(:diary).permit(:title, :body, :diary_date, :diary_image, :diary_image_cache)
  end

  def daily_create_mission_check
    result = DailyMission.update_mission(user: current_user, mission_title: '日記を投稿する')
    return unless result[:process]

    flash[:daily_missions_update] =
      t('defaults.flash_message.daily_missions_updated', item: result[:message])
  end

  def number_of_consecutive_days_check
    consecutive = current_user.consecutive_days
    result = current_user.number_of_consecutive_days(consecutive)
    return unless result[:process]

    flash[:challenge_missions_update] =
      t('defaults.flash_message.challenge_missions_updated', item: result[:message])
  end
end
