class PagesController < ApplicationController
  def logout
    redirect_to chunky_mpos + "/index.php?page=logout"
  end
end
