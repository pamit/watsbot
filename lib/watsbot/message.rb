require "httparty"
require "celluloid"

module Watsbot
  class Message < BaseResource
    include HTTParty

    def send(uid, message, **args)
      raise "uid should be provided" and return if uid.nil? or uid.empty?
      raise "message should be provided" and return if message.nil? or message.empty?

      future = Celluloid::Future.new { call(uid, message, args) }
      future.value
    end

    private

      def call(uid, message, **args)
        state = State.instance
        context = JSON.parse(state.fetch(uid)) rescue {}
        context.merge!(args.fetch(:context)) if args.has_key?(:context)
        response = call_api(message, context)
        change_state(state, uid, response, args)
        response
      end

      def change_state(state, uid, response, **args)
        if response.is_a? Response::Success
          if args.has_key?(:terminated) and args.fetch(:terminated) == true
            state.delete(uid)
          else
            state.store(uid, response.context.to_json)
          end
        else
          state.delete(uid)
        end
      end

      def call_api(message, context={})
        body = { input: { text: message }, context: context }
        options = { basic_auth: basic_auth, headers: headers, body: body.to_json }
        response = self.class.post("/workspaces/#{Watsbot.configuration.workspace}/message?version=#{Watsbot.configuration.version}", options)
        logger.info("/log/watsbot.log", "watson api _> #{options.inspect} -- #{response}")
        parser = Watsbot::Response::Parser.new response
        parser.parse
      end
  end
end
