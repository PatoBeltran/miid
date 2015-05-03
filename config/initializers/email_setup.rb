unless Rails.env.development?
  ActionMailer::Base.smtp_settings = {
    :user_name => EMAIL_CREDENTIALS[:username],
    :password => EMAIL_CREDENTIALS[:password],
    :domain => EMAIL_CREDENTIALS[:domain],
    :address => "smtp.sendgrid.net",
    :port => 587,
    :authentication => :plain,
    :enable_starttls_auto => true
  }
end
