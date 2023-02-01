module JekyllBlocker
  class Action
    def initialize(config)
      @config = config
    end

    def run(args=nil, options=nil)
      raise NotJekyllSiteError unless File.exist?(File.join(@config.root_path, "_config.yml")) &&
                                      File.exist?(File.join(@config.root_path, "Gemfile"))
    end
  end
end
