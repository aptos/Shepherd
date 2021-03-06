source 'https://rubygems.org'

ruby "2.0.0"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.6'

gem 'foreman'
# server
gem 'unicorn'

# authentication
gem 'omniauth'
gem 'omniauth-google-oauth2'

# Abort requests that are taking too long; a Rack::Timeout::Error will be raised.
# unicorn or other thread-safe server must be used.
gem "rack-timeout"

# cache
gem 'rack-cache'
gem 'dalli'
gem 'memcachier'

# Serve up precompiled compressed assets.
group :production do
  gem 'rails_12factor'
end

# db is couch
gem 'couchrest_model', '2.0.3'

# exception tracking
gem 'rollbar', '~> 1.2.8'

# gmail integration
gem 'faraday', '>= 0.9.0'

# email tracking
gem 'ahoy_email', path: 'lib/ahoy_email'

# slack integration
gem 'slack-notifier'

# javascript assets
gem 'underscore-rails'

# Bower javascript dependency manager
gem 'bower-rails'
gem 'angular-rails-templates'

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring',        group: :development

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'

# icon font
gem "font-awesome-rails"

# Use jquery as the JavaScript library
gem 'jquery-rails'

group :test, :development do
  gem "rspec-rails", "~> 2.8"
  gem "factory_girl_rails", "~> 4.0"
  gem 'faker'
  gem 'dotenv-rails'
  gem 'guard'
  gem 'guard-livereload', require: false
  gem 'pry'
  gem 'pry-byebug'
end