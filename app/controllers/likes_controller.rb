class LikesController < ApplicationController
  before_action :authenticate_user!, only: %i[create]
  skip_before_action :verify_authenticity_token

  def create
    @diary = Diary.find_by(id: params[:diary_id])
    puts "こんにちは！#{@diary.inspect}"
    @likes = current_user.like(@diary)
  end
end
