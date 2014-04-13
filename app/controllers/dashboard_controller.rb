class DashboardController < ApplicationController
  include RethinkDB::Shortcuts

  def show
    login_from_php

    @alert = Alert.get

    @display_data = Dashboard.display_data
    @latest_display_data = Hashie::Mash[@display_data.first]
  end
end
