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

# db is couch
gem 'couchrest_model', '2.0.1'

# javascript assets
gem 'underscore-rails'

# Bower javascript dependency manager
gem 'bower-rails'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'

# Use jquery as the JavaScript library
gem 'jquery-rails'

group :test, :development do
  gem "rspec-rails", "~> 2.8"
  gem "factory_girl_rails", "~> 4.0"
  gem 'faker'
  gem 'dotenv-rails'
  gem 'pry'
  gem 'pry-byebug'
end