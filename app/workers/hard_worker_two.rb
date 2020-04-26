class HardWorkerTwo
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(organizer_name, organizer_email, user_name, event_name, event_id, user_id)
    puts "================"
    UserMailer.apply_organizer(organizer_name, organizer_email, user_name, event_name, event_id, user_id).deliver_now
    puts"=============="
  end
end