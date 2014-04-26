class AccountController < ApplicationController
  def show
    login_from_php

    redirect_to login_path and return unless @current_user_id

    benchmark("getting api key") do
      @api_key = Account.where(id: @current_user_id).select(:api_key).first.try(:api_key)
    end

    benchmark("Getting coin addresses") do
      @coin_addresses = CoinAddress.where(account_id: @current_user_id)
    end

    benchmark("Extending CoinAddresses") do
      @coin_addresses.extend(CoinAddresses)
    end

    benchmark("Getting exchange rates") do
      @exchange_rates = Typhoeus.get_json_as_object(Api::Endpoint::Pool::ExchangeRates.current)
    end

    benchmark("Extending exchange rates") do
      @exchange_rates.extend(ExchangeRates)
    end

    benchmark("Getting balances") do
      @balances = Pool.balances(@api_key)
    end

    benchmark("Getting workers") do
      @workers = Pool.workers(@api_key)
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @dashboard.update(dashboard_params)
        format.html { redirect_to @dashboard, notice: 'Dashboard was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @dashboard.errors, status: :unprocessable_entity }
      end
    end
  end

  def bitcoin_value

  end

  def instrument(&block)

  end
end
