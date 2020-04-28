class HardWorkerThree
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(event_name, user_email, user_name)
    puts "================"
    UserMailer.sendDestroyNotification(event_name, user_email, user_name).deliver_now
    puts"=============="
  end

end


