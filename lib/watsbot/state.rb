require "redis"
require "singleton"

module Watsbot
  class State
    include Singleton

    def initialize
      @redis = Redis.new(:url => Watsbot.configuration.redis_url)
    end

    def fetch(key)
      @redis.get(key)
    end

    def store(key, value)
      @redis.set(key, value)
    end

    def exists?(key)
      @redis.exists(key)
    end

    def delete(key)
      @redis.del(key)
    end

  end
end
