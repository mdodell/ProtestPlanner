class EventsController < ApplicationController
  include EventsHelper
  before_action :set_event, only: [:show, :edit, :update, :destroy, :map]

  # GET /events
  # GET /events.json
  def index
    @events = Event.all
  end

  def search
        d = params[:date]
        if d == 'Any Day'
          @date = Event.where('date_from >= ?', DateTime.now)
        elsif d == 'Today'
          @date = Event.where(:date_from => DateTime.now.beginning_of_day..DateTime.now.end_of_day)
        elsif d == 'Tomorrow'
          @date = Event.where(:date_from => DateTime.tomorrow.beginning_of_day..DateTime.tomorrow.end_of_day)
        elsif d == 'This Week'
          @date = Event.where(:date_from => DateTime.now.beginning_of_week..DateTime.now.end_of_week) 
        elsif d == 'Next Week'
          @date = Event.where(:date_from => DateTime.now.beginning_of_week.advance(:days => +7)..DateTime.now.end_of_week.advance(:days => +7))
        elsif d == 'This Month'
          @date = Event.where(:date_from => DateTime.now.beginning_of_month..DateTime.now.end_of_month)
        elsif d == 'Next Month'
          @date = Event.where(:date_from => DateTime.now.beginning_of_month.advance(:months => +1)..DateTime.now.end_of_month.advance(:months => +1))
        end
        @tags = Tag.all.find(params[:tags][0]).events
      if params[:location] == ''
        @loc= Event.all
      else
        @loc= Event.all.where(location: params[:location])
      end
      
      @results =  @tags.all & @date.all & @loc.all
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
      flash[:error] = "Sorry, you don't have acces to edit"
      redirect_to root_url
    end
  end

  def addOrganizer
    event = Event.find(params[:event_id])
    if !correct_editor(current_user, event)
      flash[:error] = "Sorry, you don't have acces to edit"
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
      flash[:alert] = 'You have been removed from this event.'
      redirect_to home_path
    else
      flash[:error] = 'Sorry, you can not unregister for an event you haven\'t signed up for!'
    end
  end

  def register
    @event = Event.find(params[:id])
    if @event.nil?
      flash[:error] = 'Sorry, that event does not exist!'
      redirect_to home_path
    else
      if current_user.events.exists?(params[:id])
        flash[:error] = 'Sorry, you can\'t join because you are already part of this event.'
        redirect_to home_path
      else
        UserEventRelationship.create(event_id: @event.id, user_id: current_user.id, role_type_id: 1)
        flash[:alert] = 'You were successfully added as an attendee'
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
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
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
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
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

