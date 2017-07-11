module Watsbot
  class Configuration
    attr_accessor :username, :password, :workspace, :version,
                  :base_uri, :redis_url, :ttl

    def initialize(*args, &block)
      arg        = args.pop        || {}
      @base_uri  = BASE_URI
      @username  = arg[:username]  || ENV["WATSON_USERNAME"]
      @password  = arg[:password]  || ENV["WATSON_PASSWORD"]
      @workspace = arg[:workspace] || ENV["WATSON_WORKSPACE"]
      @version   = arg[:version]   || ENV["WATSON_WORKSPACE_VERSION"]
      @redis_url = arg[:redis_url] || ENV["REDIS_URL"]
      @ttl       = (arg[:ttl]      || ENV["TTL"]).to_i rescue -1
      yield self if block_given?
    end
  end
end
