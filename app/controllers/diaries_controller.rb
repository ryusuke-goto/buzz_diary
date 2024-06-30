# frozen_string_literal: true

class DiariesController < ApplicationController
  before_action :authenticate_user!, only: %i[new create]
  def index
    @diaries = Diary.includes(:user)
  end

  def new
    @diary = Diary.new
  end

  def create
    # start_of_today = Time.zone.now.beginning_of_day
    # end_of_today = Time.zone.now.end_of_day
    # @diary = current_user.diaries.find_by(created_at: start_of_today..end_of_today)
    # @diary = current_user.diaries.find_by(date: diary_params[:date])
    # if @diary
    #   puts 'diary has created already...'
    #   flash.now[:danger] = t('defaults.flash_message.already_created', item: Diary.model_name.human)
    #   render :new, status: :unprocessable_entity
    # else
      @diary = current_user.diaries.build(diary_params)
      if @diary.save
        redirect_to diaries_path, success: t('defaults.flash_message.created', item: Diary.model_name.human)
      else
        flash.now[:danger] = t('defaults.flash_message.not_created', item: Diary.model_name.human)
        render :new, status: :unprocessable_entity
      end
    # end
  end

  private

  def diary_params
    params.require(:diary).permit(:title, :body, :diary_date)
  end
end
