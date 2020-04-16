class MarkersChannel < ApplicationCable::Channel
  def subscribed
     stream_from "marker_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
