require "watsbot/base_resource"
require "watsbot/configuration"
require "watsbot/logger"
require "watsbot/message"
require "watsbot/state"
require "watsbot/version"
require "watsbot/response/error"
require "watsbot/response/success"
require "watsbot/response/parser"

module Watsbot
  BASE_URI = "https://gateway.watsonplatform.net/conversation/api/v1"

  def self.root
    File.dirname __dir__
  end

  class << self
    attr_writer :configuration
  end

  def self.configure
    yield(configuration)
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.reset
    @configuration = Configuration.new
  end
end
