class HardWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(user_email, user_name, event_id, content)
    puts "================"
    UserMailer.send_event_notification(user_email, user_name, event_id, content).deliver_now
    puts"=============="
  end

end
