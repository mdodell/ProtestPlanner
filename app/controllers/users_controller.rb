class UsersController < ApplicationController
  include SessionsHelper
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
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end

  #current user
  def current_user
    if session[:user_id]
      User.find_by(id: session[:user_id])
    end
  end

  def setUserLocation
    if params[:coordinates]
      session[:coordinates] = params[:coordinates]
    else
      flash[:error] = "Could not find the user coordinates"
    end
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



  def signup_for_event
    @my_event = Event.find(params[:this_event])
    @user = current_user
    if current_user.events.exists?(params[:this_event])
      flash[:alert] = 'Sorry, you can\'t join because you are already part of this event.'
      redirect_to '/my_events'
     
    else 
      UserEventRelationship.create(event_id: @my_event.id, user_id: @user.id, role_type_id: 1) 
      flash[:alert] = 'You were successfully added as an attendee'
      redirect_to '/my_events'
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
                                 :password_confirmation, :phone)
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless @user == current_user
  end
end
