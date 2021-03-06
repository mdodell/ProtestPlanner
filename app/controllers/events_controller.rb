require 'kaminari/activerecord'
class EventsController < ApplicationController
  include EventsHelper
  include SessionsHelper
  before_action :set_event, only: [:show, :edit, :update, :destroy, :map]
  before_action :require_login
  skip_before_action :verify_authenticity_token

  # GET /events
  # GET /events.json
  def index
    @organizing_future_events = get_user_organizing_future_events
    @attending_future_events = get_user_attending_future_events
    @nearby_events = get_upcoming_nearby_events_within_radius(5)
  end

  def browse
    event_params = params.permit(:keyword, :tags, :location, :latitude, :longitude, :date)
    if(!event_params[:keyword].blank? || !event_params[:tags].blank? || !event_params[:location].blank? || !event_params[:date].blank?) # If any of the search parameters exist
      @events = Event.filter(event_params)
      @events = Kaminari.paginate_array(@events.reverse).page(params[:page]).per(6)
      @search_query = params
    end
  end

  def manage_event
    @event = Event.find(params[:event_id].to_i)
    @user = current_user
  end

  def unsubscribe
    uer = UserEventRelationship.find_by(user_id: current_user.id, event_id: params[:event_id])
    uer.receive_notification = false
    uer.save
    @event_id = params[:event_id]
    respond_to do |format|
      format.html {redirect_to root_url}
      format.js
    end

  end

  def subscribe
    uer = UserEventRelationship.find_by(user_id: current_user.id, event_id: params[:event_id])
    uer.receive_notification = true
    uer.save
    @event_id = params[:event_id]
    respond_to do |format|
      format.html {redirect_to root_url}
      format.js
    end
  end

  def send_notification
    @event = Event.find(params[:event_id].to_i)
    @event.users.map do |user|
      if UserEventRelationship.find_by(user_id: user.id, event_id: @event.id).receive_notification
          HardWorker.perform_async(user.email, user.user_name, @event.id, params[:content])
      end
    end
    redirect_to @event
  end

  def remove_attendee
    @event = Event.find(params[:event_id].to_i)
    @user = User.find(params[:user_id].to_i)
    @event.users.delete(@user)
    respond_to do |format|
      format.html {redirect_to manage_event_path(@event)}
      format.js
    end

  end

  def map
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @event = Event.find(params[:id])
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
    if !correct_editor(current_user, Event.find(params[:id]))
      flash[:danger] = "Sorry, you don't have acces to edit"
      redirect_to root_url
    end
  end

  def addOrganizer
    event = Event.find(params[:event_id])
    if !correct_editor(current_user, event)
      flash[:danger] = "Sorry, you don't have acces to edit"
      redirect_to event
    else
      relation = UserEventRelationship.find_by(user_id: params[:user_id], event_id: params[:event_id])
      relation.role_type_id = 0
      if relation.save
        flash[:success] = "User #{User.find(params[:user_id]).user_name} was successfully added as organizer"
      end
      redirect_to event
    end

    end

  def unregister
    event = Event.find(params[:id])
    if current_user.events.exists?(params[:id])
      UserEventRelationship.find_by(event_id: event.id, user_id: current_user.id).destroy
      flash[:danger] = 'You have been removed from this event.'
      redirect_to home_path
    else
      flash[:danger] = 'Sorry, you can not unregister for an event you haven\'t signed up for!'
    end
  end

  def register
    @event = Event.find(params[:id])
    if @event.nil?
      flash[:danger] = 'Sorry, that event does not exist!'
      redirect_to home_path
    else
      if current_user.events.exists?(params[:id])
        flash[:danger] = 'Sorry, you can\'t join because you are already part of this event.'
        redirect_to home_path
      else
        UserEventRelationship.create(event_id: @event.id, user_id: current_user.id, role_type_id: 1)
        flash[:success] = 'You were successfully added as an attendee'
        redirect_to home_path
      end
    end
  end


  # POST /events
  # POST /events.json
  def create
    @event = Event.new(event_params)
    respond_to do | format |
      if @event.save
        if(params.require(:event).key?("tags"))
          tags = Tag.find(params.require(:event)['tags'])
        else
          tags = Tag.find_by(name: "Other") # Set default tag if none was selected
        end
        @event.tags << tags
        UserEventRelationship.create(event_id: @event.id, user_id: current_user.id, role_type_id: 0)
        format.html { redirect_to @event }
        format.json { render json: @event, status: :created, location: @event }
      else
        format.html {render 'new'}
        format.json {render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # private

  # # PATCH/PUT /events/1
  # # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event }
        flash[:info] = 'Event was successfully updated.'
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.users.map do |user|
      if UserEventRelationship.find_by(user_id: user.id, event_id: @event.id).receive_notification
        HardWorkerThree.perform_async(@event.name, user.email, user.user_name)
      end
    end

    UserEventRelationship.where(event_id: @event.id).map do |relationship|
      relationship.destroy
    end
    @event.destroy
    flash[:danger] = 'Event was successfully destroyed.'
    respond_to do |format|
      format.html { redirect_to events_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
   private

    def event_params
      params.require(:event).permit(:name, :date_from,
      :location, :date_to, :description, :picture, :tags, :latitude, :longitude)
    end

end

