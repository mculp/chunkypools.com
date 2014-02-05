class ApiController < ApplicationController
  def status
    @pool_info = Pool.pool_metastatus
    render json: @pool_info.to_json
  end

  def balances
    @balances = Pool.balances(params[:api_key])
    render json: @balances.to_json
  end
end
