class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.account_activation.subject
  #
  def account_activation(user)
    @user = user
    mail to: user.email, subject: "Account activation"
  end

  def apply_organizer(organizer, attendee, event)
    @organizer = organizer
    @attendee = attendee
    @event = event
    mail to: @organizer.email, subject: "Application to be an Organizer for event #{event.name}"
  end

  def notification(event, user)
    @event = event
    @user = user
    mail to: @user.email, subject: "Notification from RiseUp!"
  end

  def sendDestroyNotification(event_name, user)
    @user = user
    @event_name = event_name
    mail to: @user.email, subject: "Protest Cancel Notification from RiseUp!"
  end

  def send_event_notification(user, event, content)
    @user = user
    @event = event
    @content = content
    mail to: @user.email, subject: "Protest Cancel Notification from RiseUp!"
  end
end
