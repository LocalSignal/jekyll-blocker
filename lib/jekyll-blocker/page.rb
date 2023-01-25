module JekyllBlocker
  class Page
    attr_accessor :id, :title, :description, :layout, :slug, :path

    def initialize(data, config, special: nil, parent: nil)
      @config = config

      validate_data(data, special)

      set_special(special) if special
      @id     ||= data["id"].to_s.strip
      @layout ||= data["layout"].to_s.strip
      @slug   ||= data["slug"].to_s.strip

      @title       = data["title"].to_s.strip
      @description = data["description"].to_s.strip
      @path        = build_path(parent&.path)
    end

    def frontmatter
      {
        "blocker_page_id" => @id,
        "slug" => @slug,
        "layout" => @layout,
        "title" => @title,
        "description" => @description,
      }
    end

    def block_content
      @block_content ||= begin
        file_path = File.join("_blocker", "pages", @id + ".yml")
        data = Utilities.read_yaml(@config.pages_path, @id)
        unless data.instance_of?(Hash)
          raise PageFileError, "Page Content File is not a hash: #{file_path}"
        end
        unless data["blocks"].instance_of?(Hash)
          raise PageFileError, "Page Content File does not contain a blocks hash: #{file_path}"
        end
        unless data["block_containers"].instance_of?(Hash)
          message = "Page Content File does not contain a block_containers hash: #{file_path}"
          raise PageFileError, message
        end
        data
      end
    end

    private

    def error_message(id, message)
      label = if id.nil? || id.to_s.strip.empty?
                "Unknown Page"
              else
                "Page #{id}"
              end
      "config/pages.yml #{label}: #{message}"
    end

    def build_path(parent_path)
      case @id
      when "home"
        "/"
      when "not_found"
        "/404"
      else
        "#{parent_path.to_s}/#{@slug}"
      end
    end

    def validate_data(data, special)
      # make sure the page data is a hash
      unless data.instance_of? Hash
        msg = "Cannot create page from non hash value"
        raise ValidationError, error_message(nil, msg)
      end

      id = special.nil? ? data["id"].to_s.strip : special.to_s

      # check for unwanted keys
      unwanted_keys = if special.nil?
                        %w(id title description layout slug pages)
                      else
                        %w(title description)
                      end
      unwanted = data.keys - unwanted_keys
      if unwanted.any?
        msg = "The following invalid page keys were found: #{unwanted.join(', ')}"
        raise ValidationError, error_message(id, msg)
      end

      # check for needed keys
      needed_keys = if special.nil?
                        %w(id title description layout slug)
                      else
                        %w(title description)
                      end
      needed = needed_keys - data.keys
      if needed.any?
        msg = "The following page keys were not found: #{needed.join(", ")}"
        raise ValidationError, error_message(id, msg)
      end

      #check that id is some sort of value
      if id.empty?
        raise ValidationError, error_message(nil, "Page cannot have an empty id")
      end

      # check for layout
      layout = special.nil? ? data["layout"].to_s.strip : special.to_s
      if layout.empty?
        msg = "No layout specified for page"
        raise ValidationError, error_message(id, msg)
      elsif !File.exist?(File.join(@config.root_path, "_layouts", "#{layout}.html"))
        msg = "Layout specified does not exist in layouts folder"
        raise ValidationError, error_message(id, msg)
      end

      # check for slug
      if special.nil?
        if data["slug"].to_s.strip.empty?
          msg = "No slug specified for page"
          raise ValidationError, error_message(id, msg)
        end
      end

      # check title
      if data["title"].to_s.strip.empty?
        msg = "Title cannot be empty"
        raise ValidationError, error_message(id, msg)
      end

      # check description
      if data["description"].to_s.strip.empty?
        msg = "Description cannot be empty"
        raise ValidationError, error_message(id, msg)
      end

      # check pages
      if data["pages"]
        unless data["pages"].instance_of?(Array)
          msg = "Pages must be an array"
          raise ValidationError, error_message(id, msg)
        end
      end
    end

    def set_special(special)
      @id     = special.to_s
      @layout = special.to_s
      @slug   = special.to_s
    end
  end
end

