class AccountController < ApplicationController
  def show
    login_from_php redirect: true, path: "/account"

    @api_key = Account.where(id: @current_user_id).select(:api_key).first.try(:api_key)

    @balances = Pool.balances(@api_key)
    @workers = Pool.workers(@api_key)
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
end
