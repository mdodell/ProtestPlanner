class UsersController < ApplicationController
  include SessionsHelper
  before_action :set_user, only: [:edit, :update, :destroy]
  skip_before_action :require_login, only: [:new, :create, :set_user, :user_params]

  # GET /users
  # GET /users.json
  # def index
  #   @users = User.all
  # end

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
      log_in @user
      flash[:success] = "Welcome to the Course Registration App!"
      redirect_to user_url(@user)
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

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end



  def signup_for_event
    @my_event = Event.find(params[:this_event])
    @user = current_user
    unless current_user.events.exists?(params[:this_event])
      UserEventRelationship.create(event_id: @my_event.id, user_id: @user.id, role_type_id: 1) 
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
end
