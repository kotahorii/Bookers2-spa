class Api::V1::CommentsController < ApplicationController
  before_action :set_comment, only: %i[destroy]

  def create
    comment = Comment.new(comment_params)
    comment.user_id = current_api_v1_user.id
    if comment.save
      render json: { status: 200, data: message }
    else
      render json: { status: 500, data: '作成に失敗しました' }
    end
  end

  def destroy
    if @comment.destroy
      render json: { status: 200, data: '投稿を削除しました' }
    else
      render json: { status: 500, data: '削除に失敗しました' }
    end
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.permit(:comment, :book_id)
  end
end
