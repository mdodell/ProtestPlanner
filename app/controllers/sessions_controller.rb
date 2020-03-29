class SessionsController < ApplicationController
  include SessionsHelper
  skip_before_action :require_login, only: [:new, :create]

  def new
  end

  def create
    user = User.find_by(user_name: params[:user_name].downcase)
    if user && user.authenticate(params[:password])
      # Log the user in and redirect to the user's show page.
      if user.activated?
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_back_or root_path
      else
        message  = "Account not activated. "
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to login_url
      end
    else
      debugger
      # Create an error message.
      flash.now[:danger] = 'Invalid user_name/password combination'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

end
