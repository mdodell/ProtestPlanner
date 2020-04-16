class AddMarkerJob < ApplicationJob
  queue_as :default

  def perform(marker)
    sleep 1
    ActionCable.server.broadcast("marker_channel", marker)
    # Do something later
  end
end
