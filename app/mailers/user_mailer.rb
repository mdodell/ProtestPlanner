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

  def apply_organizer(organizer_name, organizer_email, user_name, event_name, event_id, user_id)
    @organizer_name = organizer_name
    @organizer_email = organizer_email
    @user_name = user_name
    @event_id = event_id
    @user_id = user_id
    mail to: organizer_email, subject: "Application to be an Organizer for event #{event_name}"
  end

  def notification(event, user)
    @event = event
    @user = user
    mail to: @user.email, subject: "Notification from RiseUp!"
  end

  def sendDestroyNotification(event_name, user_email, user_name)
    @user_name = user_name
    @event_name = event_name
    mail to: user_email, subject: "Protest Cancel Notification from RiseUp!"
  end

  def send_event_notification(user_email, user_name, event_id, content)
    @user_name = user_name
    @event_id = event_id
    @content = content
    mail to: user_email, subject: "Protest Cancel Notification from RiseUp!"
  end
end
