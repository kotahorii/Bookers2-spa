class Api::V1::CommentsController < ApplicationController
  def create
    comment = Comment.new(comment_params)

    if comment.save
      render json: { data: message }
    else
      render json: { data: '作成に失敗しました'}
    end
  end

  def destroy
    
  end

  private

  def comment_params
    params.permit(:comment, :user_id, :book_id)
  end
end
