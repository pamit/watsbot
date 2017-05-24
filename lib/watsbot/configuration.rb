module Watsbot
  class Configuration
    attr_accessor :username, :password, :workspace, :version, :base_uri, :redis_url

    def initialize(*args, &block)
      arg        = args.pop        || {}
      @username  = arg[:username]  || ENV["WATSON_USERNAME"]
      @password  = arg[:password]  || ENV["WATSON_PASSWORD"]
      @workspace = arg[:workspace] || ENV["WATSON_WORKSPACE"]
      @version   = arg[:version]   || ENV["WATSON_WORKSPACE_VERSION"]
      @base_uri  = BASE_URI
      @redis_url = arg[:redis_url] || ENV["REDIS_URL"]
      yield self if block_given?
    end
  end
end
