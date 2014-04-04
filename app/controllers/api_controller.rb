class ApiController < ApplicationController
  def pool_status
    @pool_info = Pool.statuses
    render json: @pool_info.to_json
  end

  def user_balances
    @balances = Pool.balances(params[:api_key])
    render json: @balances.to_json
  end

  def user_workers
    @workers = Pool.workers(params[:api_key])
    render json: @workers.to_json
  end

  def current_exchange_rates
    @exchange_rates = CoinPrice.current_exchange_rates
    render json: @exchange_rates.to_json
  end

  def yesterday_exchange_rates
    @exchange_rates = CoinPrice.yesterday_exchange_rates
    render json: @exchange_rates.to_json
  end
end
