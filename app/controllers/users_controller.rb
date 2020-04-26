class UsersController < ApplicationController
  include SessionsHelper
  include EventsHelper
  before_action :set_user, only: [:edit, :update, :destroy]
  skip_before_action :require_login, only: [:new, :create, :set_user, :user_params]
  before_action :correct_user,   only: [:edit, :update]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(current_user.id)
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    if @user.save
      UserMailer.account_activation(@user).deliver_now
      flash[:error] = "Please check your email to activate your account."
      redirect_to login_path
    else
      render 'new'
    end
  end

  def setUserLocation
    if params[:coordinates]
      session[:coordinates] = params[:coordinates]
    else
      flash[:error] = "Could not find the user coordinates"
    end
  end

  def applyOrganizer
    event = Event.find(params[:event_id])
    event.users.map do |user|
      if correct_editor(user, event) && UserEventRelationship.find_by(user_id: user.id, event_id: params[:event_id]).receive_notification
        HardWorkerTwo.perform_async(user.user_name, user.email, current_user.user_name, event.name, event.id, current_user.id)
      end
    end
    flash[:success] = "appllication was already sent to organizers"
    redirect_to event
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "Profile updated"
      redirect_to user_url(@user)
    else
      flash[:error] = "Fail Update!"
      render 'edit'
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit( :user_name, :email, :password,
                                 :password_confirmation, :phone, :profile, :avatar)
  end


  def correct_user()
    @user = User.find(params[:id])
    redirect_to(root_url) unless @user == current_user
  end

end