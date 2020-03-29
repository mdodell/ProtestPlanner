class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  before_action :require_login

  def require_login
    unless logged_in?
      store_location
      redirect_to login_path
    end
  end

end
