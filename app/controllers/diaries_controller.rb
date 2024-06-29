class DiariesController < ApplicationController
  def index
    @diaries = Diary.includes(:user)
  end
end
