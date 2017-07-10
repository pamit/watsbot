module Watsbot
  module Response
    class Parser

      def initialize(response)
        @response = response
        @response_body = JSON.parse(response.body)
      end

      def parse
        if @response.code >= 400
          response = Error.new @response.code
          response.message = parse_error_message
          response
        else
          response = Success.new @response.code
          response.intents = @response_body["intents"]
          response.entities = parse_entities
          response.input = @response_body["input"]
          response.output = @response_body["output"]
          response.context = @response_body["context"]
          response
        end
      end

      private

        def parse_error_message
          @response_body["error"] || @response_body["error"]["error"] rescue ""
        end

        def parse_entities
          @response_body["entities"]
        end

    end
  end
end
