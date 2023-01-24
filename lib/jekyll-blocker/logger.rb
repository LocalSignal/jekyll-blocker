module JekyllBlocker
  class Logger
    attr_reader :path

    def initialize(logger_path)
      unless Dir.exist?(logger_path)
        FileUtils.mkdir(logger_path)
      end

      file_name = "blocker_log_#{Time.now.to_i.to_s}.txt"
      @path = File.join(logger_path, file_name)
    end

    %w(info liquid error).each do |level|
      define_method(level) do |msg|
        write(message(level, msg))
      end
    end

    private

    def message(level, msg)
      "[#{Time.now.strftime("%F %T.%L")}] [#{level}] #{msg}\n"
    end

    def write(msg)
      File.open(@path, "a") do |f|
        f.write msg
      end
    end
  end
end

