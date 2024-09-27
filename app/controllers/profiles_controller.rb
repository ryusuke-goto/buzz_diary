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
    grace_period = 2 # 猶予は2日間
    my_diaries = current_user.diaries.order(created_at: :desc)
    
    my_diaries.each do |diary|
      logger.info "message::::diary: #{diary.inspect}"
  
      # 現在の past_count に該当する日付で投稿があるかを確認
      if diary.created_at.between?((Time.zone.today - past_count.day).beginning_of_day,
                                   (Time.zone.today - past_count.day).end_of_day)
        past_count += 1
        consecutive_count += 1
        logger.info 'message::count_up'
        logger.info "message::past_count #{past_count}"
  
      # 猶予期間内の投稿かを確認（1日または2日途絶えた場合）
      elsif diary.created_at.between?((Time.zone.today - (past_count + 1).day).beginning_of_day,
                                      (Time.zone.today - (past_count + grace_period).day).end_of_day)
        # 猶予内に投稿があれば連続カウントを増加
        days_skipped = (Time.zone.today.to_date - diary.created_at.to_date).to_i
        past_count += days_skipped
        consecutive_count += 1
        logger.info "message::count_up with grace period"
        logger.info "message::past_count after grace period: #{past_count}"
  
      # 3日以上空いた場合はループを終了
      else
        logger.info 'message::::Break due to more than 2 days of inactivity'
        break
      end
    end
    consecutive_count
  end
end
