# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]

  def create
    comment = current_user.comments.build(comment_params)
    if comment.save
      daily_create_mission_check
      number_of_comments_check
      redirect_to diary_path(comment.diary), success: t('defaults.flash_message.created', item: t('activerecord.models.comment'))
    else
      render diary_path(comment.diary), status: :unprocessable_entity
    end
  end

  def destroy
    comment = current_user.comments.find(params[:id])
    comment.destroy!
    redirect_to diary_path(comment.diary),
                success: t('defaults.flash_message.deleted', item: t('activerecord.models.comment'))
  end

  private

  def comment_params
    params.require(:comment).permit(:body).merge(diary_id: params[:diary_id])
  end

  def daily_create_mission_check
    result = DailyMission.update_mission(user: current_user, mission_title: 'コメントを投稿する')
    if result[:process]
      flash[:daily_missions_update] =
        t('defaults.flash_message.daily_missions_updated', item: result[:message])
    end
  end

  def number_of_comments_check
    result = current_user.number_of_comments
    if result[:process]
      flash[:challenge_missions_update] =
        t('defaults.flash_message.challenge_missions_updated', item: result[:message])
    end
  end
end
