# frozen_string_literal: true

class MemoriesController < ApplicationController
  before_action :authenticate_user!, only: %i[index]
  def index
    @diaries = Diary.with_likes_count.where(user_id: current_user.id).includes(:user)
  end
end
