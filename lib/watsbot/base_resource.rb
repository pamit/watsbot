module Watsbot
  class BaseResource
    attr_accessor :config, :logger

    def initialize(config = Watsbot.configuration)
      @config = config
      self.class.base_uri @config.base_uri
      @logger = Logger.instance
    end

    def headers
      { 'Content-Type' => 'application/json' }
    end

    def basic_auth
      { username: @config.username, password: @config.password }
    end
  end
end
