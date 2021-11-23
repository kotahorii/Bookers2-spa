class Api::V1::Auth::SessionsController < ApplicationController
  def index
    if current_api_v1_user
      render status: 200, json: current_api_v1_user
    else
      render status: 500, json: { message: 'ユーザーが存在しません' }
    end
  end
end
