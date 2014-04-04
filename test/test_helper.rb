ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :account

  # Add more helper methods to be used by all tests here...
end

def coins(name)
  yaml = YAML.load(open('./test/fixtures/coins.yml').read).deep_symbolize_keys!
  Coin.new(yaml[name])
end

def response_from(service, options)
  filename = "./test/fixtures/responses/#{service}/#{options[:coin]}.json"
  JSON.parse(open(filename).read) 
end