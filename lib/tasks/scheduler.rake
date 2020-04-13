require 'rake'
desc "Oncoming event reminder"
task :protest_reminder => :environment do
  Event.all.map do |event|
    if (event.date_from > DateTime.current) &&  (event.date_from - DateTime.current) / 3_600 <= 24
      event.users do |user|
        UserMailer.notification(event, user).deliver_now
      end
    end
  end
end