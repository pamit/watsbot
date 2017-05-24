require "bundler/setup"
require "watsbot"
require "pry"
require "simplecov"
require "webmock/rspec"
require "byebug"
require "helpers"
require "securerandom"
require "dotenv"

Dotenv.load
WebMock.enable!
SimpleCov.start

RSpec.configure do |config|
  config.example_status_persistence_file_path = ".rspec_status"
  config.disable_monkey_patching!
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
