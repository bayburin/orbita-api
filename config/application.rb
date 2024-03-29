require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_mailbox/engine'
require 'action_text/engine'
require 'action_view/railtie'
require 'action_cable/engine'
# require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module OrbitaCenter
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    ENV['http_proxy'] = ''
    ENV['https_proxy'] = ''
    ENV['HTTP_PROXY'] = ''
    ENV['HTTPS_PROXY'] = ''

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    config.time_zone = 'Krasnoyarsk'
    config.active_record.default_timezone = :local
    config.i18n.default_locale = :ru
    config.hosts << 'localhost.iss-reshetnev.ru'

    config.autoload_paths << Rails.root.join('app', 'interactors', 'concerns').to_s
    config.autoload_paths << Rails.root.join('app', 'models', 'claim').to_s
    config.autoload_paths << Rails.root.join('app', 'models', 'message').to_s
    config.autoload_paths << Rails.root.join('lib', 'modules').to_s
    config.autoload_paths << Rails.root.join('lib', 'values').to_s
    config.autoload_paths << Rails.root.join('lib', 'values', 'coerce').to_s
    config.autoload_paths << Rails.root.join('lib', 'resources').to_s
    config.autoload_paths << Rails.root.join('lib', 'queries').to_s

    config.active_job.queue_adapter = :sidekiq

    config.generators do |g|
      g.orm :active_record
      g.test_framework :rspec,
                       fixtures: true,
                       routing_specs: false,
                       request_specs: false,
                       controller_spec: true
      g.fixture_replacement :factory_bot, dir: 'spec/factories'
    end
  end
end
