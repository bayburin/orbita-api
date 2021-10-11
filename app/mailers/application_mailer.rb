class ApplicationMailer < ActionMailer::Base
  default from: ENV['ACTION_MAILER_USERNAME']
  layout 'mailer'
end
