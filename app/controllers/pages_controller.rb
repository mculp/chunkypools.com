class PagesController < ApplicationController
  before_action :login_from_php, except: [:logout]

  def logout
    redirect_to chunky_mpos + "/index.php?page=logout"
  end
end
