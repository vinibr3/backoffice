class ApplicationMailer < ActionMailer::Base
  default from: Rails.application.credentials.production[:sender_email]

  layout 'mailer'
end
