class CommentsController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]

  def create
    comment = current_user.comments.build(comment_params)
    if comment.save
      redirect_to diary_path(comment.diary), success: t('defaults.flash_message.created',  item: t('activerecord.models.comment'))
    else
      # redirect_to diary_path(comment.diary), danger: t('defaults.flash_message.not_created', item: t('activerecord.models.comment'))
      render diary_path(comment.diary), status: :unprocessable_entity
    end
  end

  def destroy
    comment = current_user.comments.find(params[:id])
    comment.destroy!
    redirect_to diary_path(comment.diary), success: t('defaults.flash_message.deleted', item: t('activerecord.models.comment'))
  end
  
  private

  def comment_params
    params.require(:comment).permit(:body).merge(diary_id: params[:diary_id])
  end
end
