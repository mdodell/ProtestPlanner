class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  # GET /events
  # GET /events.json
  def index
    @events = Event.all
  end

  def search
    #results1 is not working because date is not exact 
      @date_results = Event.all.where('date_to >= ?', params[:date]).limit(3).order("date_to DESC")
      @loc_results = Event.all.where(location: params[:location])
      if params[:tags] == nil
        @results = @date_results.all + @loc_results.all 
      else
        @tags = Tag.all.find(params[:tags][0]).events
        @results = @date_results.all + @loc_results.all + @tags.all
      end
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
    if !correct_editor
      flash[:error] = "Sorry, you don't have acces to edit"
      redirect_to root_url
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
        format.html { redirect_to @event, status: :permanent_redirect, notice: 'Event was successfully created.' }
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

  def correct_editor
    @user = current_user
    (@user.user_event_relationships.map{|x| x[:event_id]}.include? params[:id].to_i) && (RoleTypePermission.find_by(id: UserEventRelationship.find_by(user_id: @user.id, event_id: params[:id]).role_type_id).modify_event)
  end
end

