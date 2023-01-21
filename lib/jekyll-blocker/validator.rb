module JekyllBlocker
  class Validator
    attr_reader :errors

    class << self
      def analyze(&block)
        validator = Validator.new
        validator.instance_eval(&block)
        validator.errors
      end
    end

    def initialize
      @errors = []
    end

    def pages_config
      unless File.exist?(File.join(Config.config_path, "pages.yml"))
        @errors << "pages.yml does not exist"
        return
      end

      data = Utilities.read_yaml(Config.config_path, "pages")

      unless data.instance_of?(Hash)
        @errors << "pages.yml does not contain a hash"
        return
      end

      unwanted = data.keys - %w(title description not_found pages)
      if unwanted.any?
        @errors << "config/pages.yml: The following invalid root keys were found: #{unwanted.join(", ")}"
      end

      needed = %w(title description not_found pages) - data.keys
      if needed.any?
        @errors << "config/pages.yml: The following root keys were not found: #{needed.join(", ")}"
      end

      #check root level keys
      check_type "title", data["title"], String, "config/pages.yml Root"
      check_type "description", data["description"], String, "config/pages.yml Root"
      if check_type "not_found", data["not_found"], Hash, "config/pages.yml Root"
        check_type "title",
          data.dig("not_found", "title"),
          String,
          "config/pages.yml not_found"
        check_type "description",
          data.dig("not_found", "description"),
          String,
          "config/pages.yml not_found"
      end
      if check_type "pages", data["pages"], Array, "config/pages.yml Root"
        check_pages(data["pages"])
      end
    end

    private

    def check_pages(pages)
      pages.each do |page|
        unwanted = page.keys - %w(id title description layout slug pages)
        if unwanted.any?
          @errors << "config/pages.yml Page #{page["id"]}: The following invalid page keys were found: #{unwanted.join(", ")}"
          next
        end

        needed = %w(id title description layout slug) - page.keys
        if needed.any?
          @errors << "config/pages.yml Page #{page["id"]}: The following page keys were not found: #{needed.join(", ")}"
          next
        end

        if page["id"] == "home" || page["id"] == "not_found"
          @errors << "config/pages.yml Page #{page["id"]}: Interior page using reserved id #{page["id"]}"
          next
        end

        error = "config/pages.yml Page #{page["id"]}: "
        errors = []

        unless page["id"].instance_of?(String) || page["id"].instance_of?(Integer) || page["id"].instance_of?(Float)
          errors << "invalid id"
        end


        %w(title description layout slug).each do |key|
          unless page[key].instance_of?(String)
            errors << "invalid #{key}"
          end
        end

        unless page["pages"].instance_of?(Array) || page["pages"].nil?
          errors << "invalid pages"
        end

        if errors.any?
          @errors << (error + errors.join(", "))
        end

        if page["pages"].instance_of?(Array)
          check_pages(page["pages"])
        end
      end
    end

    def check_type(name, value, type, intro)
      types = type.instance_of?(Array) ? type : [type]

      if types.find { |t| value.instance_of?(t) }
        return true
      end

      @errors << "#{intro}: '#{name}' is a #{value.class.name} when it should be a #{types.join(" or ")}"
      false
    end
  end
end
