class Api::V1::FavoritesController < ApplicationController
  def index
    render json: { status: 200, data: current_api_v1_user.favorites }
  end

  def create
    favorite = current_api_v1_user.favorites.new(favorite_params)
    if favorite.save
      render json: { status: 200, data: favorite }
    else
      render json: { status: 500, data: '作成に失敗しました' }
    end
  end

  def destroy
    favorite = current_api_v1_user.favorites.find_by(favorite_params)
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
