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
      logger.info "message::diary: #{diary.inspect}"
      if diary.created_at.between?((Time.zone.today - past_count.day).beginning_of_day,
                                   (Time.zone.today - past_count.day).end_of_day)
# created_at.to_dateとdiary_dateが一致している日記なら連続投稿記録カウントを進める
        if diary.created_at.to_date == diary.diary_date
          past_count += 1
          consecutive_count += 1
          logger.info "message:: count up #{consecutive_count}"
          logger.info "message:: count up past #{past_count}"
        else
          past_count += 1
          logger.info 'message:: but different diary_date...not count up'
        end
# 一個前のレコードと同じcreated_at.to_dateかどうか検証。
# 同じcreated_at.to_dateのレコードの中から、diary_dateが一致するものを探すため。
      elsif diary.created_at.between?((Time.zone.today - (past_count - 1).day).beginning_of_day,
                                      (Time.zone.today - (past_count - 1).day).end_of_day) && diary.created_at.to_date != diary.diary_date
        logger.info 'message:: Same created_at as the previous record'
        if diary.created_at.to_date == diary.diary_date
          consecutive_count += 1
          logger.info "message:: count up #{consecutive_count}"
          logger.info "message:: count up past #{past_count}"
        else
          logger.info 'message:: but different diary_date...not count up & past_count'
        end
# 1日空いた後に日記があるかを確認。カウントが進むことを許容する。
      elsif diary.created_at.between?((Time.zone.today - (past_count + 1).day).beginning_of_day,
                                      (Time.zone.today - (past_count + 1).day).end_of_day)
        logger.info 'message::created_at Yesterdays diary was there. OK'
        if diary.created_at.to_date == diary.diary_date
          past_count += 1
          consecutive_count += 1
          logger.info "message:: count up #{consecutive_count}"
          logger.info "message:: count up past #{past_count}"
        else
          past_count += 1
          logger.info 'message:: but different diary_date...not count up'
        end
# 2日空いた後に日記があるかを確認。カウントが進むことを許容する。
      elsif diary.created_at.between?((Time.zone.today - (past_count + 2).day).beginning_of_day,
                                      (Time.zone.today - (past_count + 2).day).end_of_day) && diary.created_at.to_date == diary.diary_date
        logger.info 'message::created_at 2days ago diary was there. OK'
        if diary.created_at.to_date == diary.diary_date
          past_count += 2
          consecutive_count += 1
          logger.info "message:: count up #{consecutive_count}"
          logger.info "message:: count up past #{past_count}"
        else
          past_count += 2
          logger.info 'message:: but different diary_date...not count up'
        end
      else
        logger.info 'message::each loop break'
        break
      end
    end
    consecutive_count
  end

  # def number_of_consecutive_days
  #   past_count = 0
  #   consecutive_count = 0
  #   grace_period = 2 # 猶予は2日間
  #   my_diaries = current_user.diaries.order(created_at: :desc)
    
  #   my_diaries.each do |diary|
  #     logger.info "message::::diary: #{diary.inspect}"
  
  #     # 現在の past_count に該当する日付で投稿があるかを確認
  #     if diary.created_at.between?((Time.zone.today - past_count.day).beginning_of_day,
  #                                  (Time.zone.today - past_count.day).end_of_day)
  #       past_count += 1
  #       consecutive_count += 1
  #       logger.info 'message::count_up'
  #       logger.info "message::past_count #{past_count}"
  
  #     # 猶予期間内の投稿かを確認（1日または2日途絶えた場合）
  #     elsif diary.created_at.between?((Time.zone.today - (past_count + 1).day).beginning_of_day,
  #                                     (Time.zone.today - (past_count + grace_period).day).end_of_day)
  #       # 猶予内に投稿があれば連続カウントを増加
  #       logger.info "message::#{(Time.zone.today - (past_count + 1).day).beginning_of_day}"
  #       logger.info "message::#{(Time.zone.today - (past_count + grace_period).day).end_of_day}"
  #       days_skipped = (Time.zone.today.to_date - diary.created_at.to_date).to_i
  #       past_count += days_skipped
  #       consecutive_count += 1
  #       logger.info "message::count_up with grace period"
  #       logger.info "message::past_count after grace period: #{past_count}"
  
  #     # 3日以上空いた場合はループを終了
  #     else
  #       logger.info 'message::::Break due to more than 2 days of inactivity'
  #       break
  #     end
  #   end
  #   consecutive_count
  # end
end
