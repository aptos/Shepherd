ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)


require 'rspec/rails'
require 'rspec/autorun'
require 'dotenv'

Dotenv.load


# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

# Read ENV from .env

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!

# reset test db for each spec
config.before(:each) do
  unless ENV['PERSIST']
    CouchRest::Model::Base.database.recreate! rescue nil
  end
end

OmniAuth.config.test_mode = true
OmniAuth.config.mock_auth[:linkedin] = OmniAuth::AuthHash.new({
  :provider => 'linkedin',
  :uid => 'faker@taskit.io',
  :info => {'email' => "faker@taskit.io"},
  :credentials => {
     "token" => "6c1ee1f1-5a08-4490-830c-f6dc289a1335",
     "secret" => "0f650b65-f215-4d31-ab50-da393c8b5c39"
  }
  })

OmniAuth.config.mock_auth[:google] = OmniAuth::AuthHash.new({
  :provider => 'google',
  :email => 'brian@taskit.io',
  :credentials => {
    "token" => "ya29.tgBWkugGIHHikdLmiyUSvpPB3r8wYwe_05FOwVUKyJ7szLpKI-UlaubMXneofG7TmDyT6yDi4SeYdQ",
    "expires_at" => 1415304668,
    "expires" => true
  }
})

  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  # config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  # config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = true

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  # config.order = "random"
end
