class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  before_action :require_login

  def remote_ip
    if request.remote_ip == '127.0.0.1'
      # Hard coded remote address
      '123.45.67.89'
    else
      request.remote_ip
    end
  end

  def require_login
    unless logged_in?
      # flash[:error] = "You must be logged in to access this section"
      redirect_to login_path# halts request cycle
    end
  end

  def hello
    render html: "Hello Protest Planner!"
  
  end

end
