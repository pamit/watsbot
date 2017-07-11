require "httparty"
require "celluloid"

module Watsbot
  class Message < BaseResource
    include HTTParty
    attr_reader :state

    def send(uid, message, **args)
      raise "uid should be provided" and return if uid.nil? or uid.empty?
      raise "message should be provided" and return if message.nil? or message.empty?

      future = Celluloid::Future.new { call(uid, message, args) }
      future.value
    end

    private

      def call(uid, message, **args)
        @state = State.instance
        context = JSON.parse(@state.fetch(uid)) rescue {}
        context.merge!(args.fetch(:context)) if args.has_key?(:context)
        response = call_api(message, context)
        change_state(uid, response, args)
        response
      end

      def change_state(uid, response, **args)
        if response.is_a? Response::Success
          if args.has_key?(:terminated) and args.fetch(:terminated) == true
            @state.delete(uid)
          else
            @state.store(uid, response.context.to_json)
            set_ttl(uid)
          end
        else
          @state.delete(uid)
        end
      end

      def set_ttl(uid)
        return if config.ttl == -1
        message_ttl = @state.ttl(uid)
        if message_ttl == -1 or message_ttl == -2
          @state.expire(uid, config.ttl)
        end
      end

      def call_api(message, context={})
        body = { input: { text: message }, context: context }
        options = { basic_auth: basic_auth, headers: headers, body: body.to_json }
        response = self.class.post("/workspaces/#{config.workspace}/message?version=#{config.version}", options)
        logger.info("/log/Watsbot.log", "watson api _> #{options.inspect} -- #{response}")
        parser = Watsbot::Response::Parser.new response
        parser.parse
      end
  end
end
