require 'exception_notification/rails'
require 'exception_notification/sidekiq'

ExceptionNotification.configure do |config|
  # Ignore additional exception types.
  # ActiveRecord::RecordNotFound, Mongoid::Errors::DocumentNotFound, AbstractController::ActionNotFound and ActionController::RoutingError are already added.
  # config.ignored_exceptions += %w{ActionView::TemplateError CustomError}

  # Adds a condition to decide when an exception must be ignored or not.
  # The ignore_if method can be invoked multiple times to add extra conditions.
  config.ignore_if do |exception, options|
    !Rails.env.production? && !Rails.env.staging?
  end

  # Ignore exceptions generated by crawlers
  # config.ignore_crawlers %w{Googlebot bingbot}

  # Notifiers =================================================================

  # Email notifier sends notifications by email.
  config.add_notifier :email, {
    email_prefix: '[ORBITA-BUG-REPORT] ',
    # deliver_with: :deliver_later,
    sender_address: ENV['ERROR_NOTIFICATION_EMAIL_SENDER'],
    exception_recipients: %w{bayburin@iss-reshetnev.ru},
    sections: %w{user_info request session environment backtrace}
  }

  config.add_notifier :mattermost, {
    webhook_url: ENV['ERROR_NOTIFICATION_MATTERMOST_WEBHOOK_URL'],
    username: ENV['ERROR_NOTIFICATION_MATTERMOST_USERNAME']
  }
end
