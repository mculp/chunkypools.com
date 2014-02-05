class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  CHUNKY_URL = 'https://pool.chunky.ms/'

  helper_method :chunky_url, :chunky_mpos

  def login_from_php(options = {})
    if @logged_in = true || env['php.session'] && env['php.session']['AUTHENTICATED']
      @current_user = 'zergbeef' || env['php.session']['USERDATA']['username']
      @current_user_id = 5 || env['php.session']['USERDATA']['id']
    end

    if options[:redirect] && !@logged_in
      flash[:error] = "You must be logged in to view this page."
      flash[:redirect] = options[:path] # TODO: automate this
      redirect_to login_path
    end
  end

  def chunky_url
    CHUNKY_URL
  end

  def chunky_mpos
    chunky_url + 'doge'
  end
end
