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

    def configure(&block)
      yield(configuration)
    end

    def configuration
      @configuration ||= Configuration.new
    end

    def reset
      @configuration = Configuration.new
    end
  end
end
