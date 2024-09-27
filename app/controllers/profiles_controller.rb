# frozen_string_literal: true

class ProfilesController < ApplicationController
  before_action :authenticate_user!, only: %i[show]
  def show
    @past_count = number_of_consecutive_days
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

  private

  def number_of_consecutive_days
    past_count = 0
    consecutive_count = 0
    my_diaries = current_user.diaries.order(created_at: :desc)
    my_diaries.each do |diary|
      logger.info "message::::diary: #{diary.inspect}"
      if diary.created_at.between?((Time.zone.today - past_count.day).beginning_of_day,
                                   (Time.zone.today - past_count.day).end_of_day)
        past_count += 1
        consecutive_count += 1
      elsif diary.created_at.between?((Time.zone.today - (past_count - 1).day).beginning_of_day,
                                      (Time.zone.today - (past_count - 1).day).end_of_day)
        logger.info 'message::::Same created_at and different diary_date...not count up'
      elsif diary.created_at.between?((Time.zone.today - (past_count + 1).day).beginning_of_day,
                                      (Time.zone.today - (past_count + 1).day).end_of_day)
        logger.info 'message::::created_at Yesterdays diary was there. OK'
        if past_count == 0
          past_count += 2
        else
          past_count += 3
        end
        consecutive_count += 1
      elsif diary.created_at.between?((Time.zone.today - (past_count + 2).day).beginning_of_day,
                                      (Time.zone.today - (past_count + 2).day).end_of_day)
        logger.info 'message::::created_at 2days ago diary was there. OK'
        if past_count == 0
          past_count += 3
        else
          past_count += 4
        end
        consecutive_count += 1
      else
        logger.info 'message::::each loop break'
        break
      end
    end
    consecutive_count
  end
end
