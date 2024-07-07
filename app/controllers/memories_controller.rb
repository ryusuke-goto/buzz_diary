# frozen_string_literal: true

class MemoriesController < ApplicationController
  before_action :authenticate_user!, only: %i[index]
  def index
    @diaries = Diary.where(user_id: current_user.id)
  end
end
