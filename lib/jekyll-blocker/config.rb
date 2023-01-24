module JekyllBlocker
  class Config
    def initialize(root_path)
      if !root_path.instance_of?(String)
        raise ConfigError, "Config root path is not a string"
      end
      if root_path.strip.empty?
        raise ConfigError, "Config root path is empty"
      end
      if !Dir.exist?(root_path)
        raise ConfigError, "Config root path does not exist"
      end
      @root_path = root_path
    end

    def root_path
      @root_path
    end

    def blocker_path
      @blocker_path ||= File.join(root_path, "_blocker")
    end

    def config_path
      @config_path ||= File.join(blocker_path, "config")
    end

    def blocks_path
      @blocks_path ||= File.join(blocker_path, "blocks")
    end

    def pages_path
      @pages_path ||= File.join(blocker_path, "pages")
    end

    def logger_path
      @logger_path ||= File.join(root_path, "_log")
    end
  end
end
