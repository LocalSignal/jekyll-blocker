module JekyllBlocker
  class RedirectCollection
    attr_reader :redirects
    def all() @redirects end

    def initialize(config)
      @redirects = Utilities.read_yaml(config.config_path, "redirects")
      @redirects = [] unless redirects.instance_of?(Array)
      @redirects.select! do |redirect|
        redirect.instance_of?(Hash) &&
        redirect["from"].instance_of?(String) &&
        redirect["to"].instance_of?(String)
      end
    end
  end
end

