class CommentsController < ApplicationController
  before_action :authenticate_user!, only: %i[create]

  def create
    comment = current_user.comments.build(comment_params)
    if comment.save
      redirect_to diary_path(comment.diary), success: t('defaults.flash_message.created', item: Comment.model_name.human)
    else
      redirect_to diary_path(comment.diary), danger: t('defaults.flash_message.not_created', item: Comment.model_name.human)
    end
  end
  
  private

  def comment_params
    params.require(:comment).permit(:body).merge(diary_id: params[:diary_id])
  end
end
