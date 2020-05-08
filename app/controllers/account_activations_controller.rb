class AccountActivationsController < ApplicationController
  skip_before_action :require_login, only: [:edit]
  def edit
    user = User.find_by(user_name: params[:user_name])
    puts "haha"
    puts user.id
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      puts "here I am"
      user.activate
      log_in user
      flash[:success] = "Account activated!"
      redirect_to root_url
    else
      puts "cry"
      flash[:danger] = "Invalid activation link"
      redirect_to login_url
    end
  end
end
