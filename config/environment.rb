# Load the Rails application.
require_relative 'application'

Rails.application.configure do

  config.action_mailer.delivery_method = :smtp

  config.action_mailer.smtp_settings = {
      address:              'smtp.gmail.com',
      port:                 587,
      domain:               'gmail.com',
      user_name:            'riseup.protestplanner@gmail.com',
      password:             'riseup123!',
      authentication:       'plain',
      enable_starttls_auto: true
  }
end

# Initialize the Rails application.
Rails.application.initialize!
