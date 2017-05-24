module Watsbot
  module Response
    Success = Struct.new(:code, :intents, :entities, :input, :output, :context) do; end
  end
end
