source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.2'

gem 'active_model_serializers'
gem 'anycable-rails'
gem 'awesome_print'
gem 'carrierwave'
gem 'carrierwave-i18n'
gem 'colorize'
gem 'devise'
gem 'dotenv-rails'
gem 'doorkeeper'
gem 'doorkeeper-i18n'
gem 'faraday'
gem 'faraday_middleware'
gem 'interactor'
gem 'jwt'
gem 'mysql2', '>= 0.4.4'
gem 'oj'
gem 'rack-cors'
gem 'reform'
gem 'reform-rails'
gem 'sidekiq'
gem 'virtus'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.3', '>= 6.0.3.2'

# Use Puma as the app server
gem 'puma', '~> 4.1'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

group :development, :test do
  gem 'brakeman'
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'fuubar'
  gem 'rspec-rails', '~> 4.0.1'
end

group :development do
  gem 'listen', '~> 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  gem 'bullet'
  gem 'guard'
  gem 'guard-rspec', require: false
  gem 'solargraph'
  # gem 'pry-rails'
end

group :test do
  gem 'json_spec'
  gem 'rails-controller-testing'
  gem 'rspec-its'
  gem 'shoulda-matchers'
  gem 'simplecov', require: false
  gem 'webmock'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
