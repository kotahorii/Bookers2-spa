class Api::V1::FavoritesController < ApplicationController
  def index
    render json: { status: 200, data: current_api_v1_user.favorites }
  end

  def create
    book = Book.find(favorite_params)
    favorite = current_api_v1_user.favorites.new(book_id: book.id)
    if favorite.save
      render json: { status: 200, data: favorite }
    else
      render json: { status: 500, data: '作成に失敗しました' }
    end
  end

  def destroy
    book = Book.find(favorite_params)
    favorite = current_api_v1_user.favorites.find_by(book_id: book.id)
    if favorite.destroy
      render json: { status: 200, data: '削除しました' }
    else
      render json: { status: 500, data: '削除に失敗しました' }
    end
  end

  private

  def favorite_params
    params.permit(:book_id)
  end
end
