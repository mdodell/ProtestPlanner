class AddMarkerJob < ApplicationJob
  queue_as :default

  def perform(marker)
    ActionCable.server.broadcast("marker_channel", marker)
  end
end
