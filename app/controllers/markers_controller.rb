class MarkersController < ApplicationController
  include SessionsHelper
  def create
    @marker = MapMarker.create(user_id: current_user.id,
                           event_id: params[:event_id],
                           latitude: session[:coordinates]["latitude"],
                           longitude: session[:coordinates]["longitude"]
    )
    case params[:marker_type]
        when "rally_point"
          @marker.rally_point!
        when "police"
          @marker.police!
        when "counter_protestors"
          @marker.counter_protestors!
        when "end"
          @marker.end!
        when "road_blocked"
          @marker.road_blocked!
    end
    AddMarkerJob.perform_now(@marker.to_json)
  end

  def show
    @markers = MapMarker.where(event_id: params[:event_id])
    respond_to do | format |
      format.json { render json: @markers }
    end
  end
end
