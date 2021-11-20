class Api::V1::RatesController < ApplicationController
  before_action :set_rate, except: %i[index create]
  def index
    rates = Rate.all.order(created_at: 'DESC')
    render json: rates
  end

  def create
    rate = current_api_v1_user.rates.new(rate_params)
    if rate.save
      render json: rate
    else
      render json: { data: '作成に失敗しました' }
    end
  end

  def update
    @rate.rate = rate_params[:rate]
    @rate.book_id = rate_params[:book_id]
    @rate.user_id = current_api_v1_user.id

    if @rate.save
      render json: @rate
    else
      render json: { data: '更新に失敗しました' }
    end
  end

  private

  def set_rate
    @rate = Rate.find(params[:id])
  end

  def rate_params
    params.permit(:book_id, :rate)
  end
end
