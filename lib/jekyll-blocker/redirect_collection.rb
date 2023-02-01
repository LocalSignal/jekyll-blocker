module JekyllBlocker
  class RedirectCollection
    attr_reader :redirects
    def all() @redirects end

    def initialize(config)
      @path = File.join(config.config_path, "redirects.yml")
      @redirects = if File.exist?(@path)
                     Utilities.read_yaml(config.config_path, "redirects")
                   else
                     []
                   end
      validate @redirects
    end

    def add(redirect)
      validate_redirect redirect
      @redirects << redirect

      # TODO clean redirects. look for loops and slim down number of jumps

      File.open(@path, "w") do |file|
        file.write(@redirects.to_yaml.sub(/\A---/, '').strip)
      end
    end

    private

    def validate(data)
      unless data.instance_of? Array
        raise ValidationError, "config/redirects.yml: Root must be an array"
      end

      data.each do |redirect|
        validate_redirect redirect
      end
    end

    def validate_redirect(redirect)
      unless redirect.instance_of? Hash
        msg = <<~MSG
          config/redirects.yml: A redirect is not a hash
          #{redirect.to_yaml.gsub(/\A---/, '')}
        MSG
        raise ValidationError, msg.strip
      end

      # check for unwanted keys
      unwanted = redirect.keys - %w(from to)
      if unwanted.any?
        msg = <<~MSG
          config/redirects.yml: Invalid keys were found: #{unwanted.join(', ')}
          #{redirect.to_yaml.gsub(/\A---/, '')}
        MSG
        raise ValidationError, msg.strip
      end

      # check for needed keys
      needed = %w(from to) - redirect.keys
      if needed.any?
        msg = <<~MSG
          config/redirects.yml: Required keys were not found: #{needed.join(", ")}
          #{redirect.to_yaml.gsub(/\A---/, '')}
        MSG
        raise ValidationError, msg.strip
      end

      unless redirect["from"].instance_of?(String)
        msg = <<~MSG
          config/redirects.yml: 'from' key must be a string
          #{redirect.to_yaml.gsub(/\A---/, '')}
        MSG
        raise ValidationError, msg.strip
      end

      unless redirect["to"].instance_of?(String)
        msg = <<~MSG
          config/redirects.yml: 'to' key must be a string
          #{redirect.to_yaml.gsub(/\A---/, '')}
        MSG
        raise ValidationError, msg.strip
      end
    end
  end
end

