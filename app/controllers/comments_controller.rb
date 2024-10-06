# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]
  before_action :set_comment, only: %i[destroy]
  before_action :verify_access, only: %i[destroy]

  def create
    comment = current_user.comments.build(comment_params)
    if comment.save
      daily_create_mission_check
      number_of_comments_check
      redirect_to diary_path(comment.diary),
                  success: t('defaults.flash_message.created', item: t('activerecord.models.comment'))
    else
      render diary_path(comment.diary), status: :unprocessable_entity
    end
  end

  def destroy
    @comment.destroy!
    redirect_to diary_path(comment.diary),
                success: t('defaults.flash_message.deleted', item: t('activerecord.models.comment'))
  end

  private

  def set_comment
    @diary = Comment.find(params[:id])
  end

  def verify_access
    redirect_to root_url, alert: 'Forbidden access.' unless current_user.my_object?(@comment)
  end

  def comment_params
    params.require(:comment).permit(:body).merge(diary_id: params[:diary_id])
  end

  def daily_create_mission_check
    result = DailyMission.update_mission(user: current_user, mission_title: 'コメントを投稿する')
    return unless result[:process]

    flash[:daily_missions_update] =
      t('defaults.flash_message.daily_missions_updated', item: result[:message])
  end

  def number_of_comments_check
    result = current_user.number_of_comments
    return unless result[:process]

    flash[:challenge_missions_update] =
      t('defaults.flash_message.challenge_missions_updated', item: result[:message])
  end
end
