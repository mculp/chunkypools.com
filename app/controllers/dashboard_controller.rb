class DashboardController < ApplicationController
  def show
    login_from_php

    @alert = Alert.get

    @display_data = Dashboard.display_data
    @latest_display_data = Hashie::Mash[@display_data.first]

    @scrypt_display_data = @latest_display_data.scrypt
    @x11_display_data = @latest_display_data.x11
    @sha256_display_data = @latest_display_data.sha256

    @flattened_pool_data = @scrypt_display_data.pools + @x11_display_data.pools + @sha256_display_data.pools

    @hash = Pool.status('doge')[:hash_rate] rescue 0
  end
end
