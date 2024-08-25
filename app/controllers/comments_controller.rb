# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]

  def create
    comment = current_user.comments.build(comment_params)
    if comment.save
      result = DailyMission.update_mission(user: current_user, mission_title: 'コメントを投稿する')
      if result[:process]
        flash[:daily-missions-update] =
          t('defaults.flash_message.daily_missions_updated', item: result[:message])
      end
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
end
