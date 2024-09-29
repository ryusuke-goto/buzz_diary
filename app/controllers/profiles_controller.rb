# frozen_string_literal: true

class ProfilesController < ApplicationController
  before_action :authenticate_user!, only: %i[show]
  def show
    @past_count = current_user.consecutive_days
    @friendship = current_user.get_friendship_status
    logger.info "message::::@friendship_result: #{@friendship}"
    @comments_count = current_user.comments.count
    @likes_count = current_user.likes.count
  end

  def update_remind
    if current_user.toggle!(:remind)
      puts 'remind updated'
    else
      flash.now[:danger] = t('defaults.flash_message.not_updated', item: '設定')
      render :show, status: :unprocessable_entity
    end
  end
end
