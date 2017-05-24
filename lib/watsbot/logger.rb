require "logger"
require "singleton"

module Watsbot
  class Logger
    include Singleton

    def debug(path, message)
      ::Logger.new(make_log_file(path), "daily").debug(message)
    end

    def error(path, message)
      ::Logger.new(make_log_file(path), "daily").error(message)
    end

    def info(path, message)
      ::Logger.new(make_log_file(path), "daily").info(message)
    end

    def warn(path, message)
      ::Logger.new(make_log_file(path), "daily").warn(message)
    end

    def raw_log(path, message)
      full_path = make_log_file(path)
      File.open(full_path, "a+") { |f| f.puts("R, [#{DateTime.now.as_json}]  RAW -- : " + message) }
    end

    private

      def make_log_file(path)
        log_address = "#{Watsbot.root}#{path}"
        make_dir(File.dirname(log_address))
        make_file(log_address)
        log_address
      end

      def make_dir(path)
        if (!File.directory? path)
          FileUtils.mkpath path
        end
      end

      def make_file(path_to_file)
        if (!File.exists? path_to_file)
          FileUtils.touch path_to_file
        end
      end
  end
end
