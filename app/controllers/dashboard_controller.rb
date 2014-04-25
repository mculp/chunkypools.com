class DashboardController < ApplicationController
  def show
    login_from_php

    @alert = Alert.get

    @display_data = Dashboard.display_data
    @latest_display_data = Hashie::Mash[@display_data.first]

    @hash = Pool.status('doge')[:hash_rate] rescue 0
  end
end
