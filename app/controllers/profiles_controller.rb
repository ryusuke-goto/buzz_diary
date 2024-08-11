# frozen_string_literal: true

class ProfilesController < ApplicationController
  before_action :authenticate_user!, only: %i[show]
  def show; end

  def update_remind
    if current_user.toggle!(:remind)
      puts 'remind updated'
    else
      flash.now[:danger] = t('defaults.flash_message.not_updated', item: '設定')
      render :show, status: :unprocessable_entity
    end
  end
end
