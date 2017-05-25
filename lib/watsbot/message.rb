require "httparty"
require "celluloid"

module Watsbot
  class Message < BaseResource
    include HTTParty

    def send(uid, message, context={})
      raise "uid should be provided" and return if uid.nil? or uid.empty?
      raise "message should be provided" and return if message.nil? or message.empty?

      future = Celluloid::Future.new { call(uid, message, context={}) }
      future.value
    end

    private

      def call(uid, message, context=nil)
        state = State.instance
        context ||= JSON.parse(state.fetch(uid)) rescue nil
        response = call_api(message, context)
        change_state(state, uid, response)
        response
      end

      def change_state(state, uid, response)
        if response.is_a? Response::Success
          if response.context["system"]["branch_exited_reason"] == 'completed'
            state.delete(uid)
          elsif response.context["system"]["branch_exited_reason"] != 'fallback'
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
