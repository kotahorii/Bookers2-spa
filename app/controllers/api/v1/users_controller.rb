class Api::V1::UsersController < ApplicationController
  before_action :set_user, only: %i[show update]

  def index
    users = User.all.order(created_at: 'DESC')
    render json: users
  end

  def update
    @user.name = user_params[:name]
    @user.introduction = user_params[:introduction]
    @user.image = user_params[:image] if user_params[:image] != ''

    if @user.save
      render status: 200, json: @user
    else
      render status: 401, json: { message: '更新に失敗しました' }
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.permit(:name, :introduction, :image)
  end
end
