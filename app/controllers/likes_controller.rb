# frozen_string_literal: true

class LikesController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  def create
    @diary = Diary.find_by(id: params[:diary_id])
    current_user.like(@diary)
  end

  def everything
    @diaries = Diary.where(diary_date: Date.today).includes(:user)
    if @diaries
    end
  end
end
