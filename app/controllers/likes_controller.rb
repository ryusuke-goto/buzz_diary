class LikesController < ApplicationController
  before_action :authenticate_user!, only: %i[create update]

  def create
  end

  def update
  end
end
