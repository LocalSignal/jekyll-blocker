module JekyllBlocker
  class Page
    attr_reader :id, :title, :description, :layout, :slug, :parent, :path

    def initialize(data, config, special: nil, parent: nil)
      @config = config

      validate(data, special)

      set_special(special) if special
      @id     ||= data["id"].to_s.strip
      @layout ||= data["layout"].to_s.strip
      @slug   ||= data["slug"].to_s.strip

      @title       = data["title"].to_s.strip
      @description = data["description"].to_s.strip
      @path        = build_path(parent&.path)
      @parent      = data["parent"] || parent&.id
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
      @block_content ||= load_block_content
    end

    def load_block_content
      data = Utilities.read_yaml(@config.pages_path, @id)
      validate_content data
      data
    end

    def to_h
      if %w(home not_found).include?(@id)
        {
          "title" => @title,
          "description" => @description,
        }
      else
        {
          "id" => @id,
          "title" => @title,
          "description" => @description,
          "slug" => @slug,
          "layout" => @layout
        }
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

    def validate(data, special)
      # make sure the page data is a hash
      unless data.instance_of? Hash
        msg = "Cannot create page from non hash value"
        raise ValidationError, error_message(nil, msg)
      end

      id = special.nil? ? data["id"].to_s.strip : special.to_s

      # check for unwanted keys
      unwanted_keys = if special.nil?
                        %w(id title description layout slug pages parent)
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

    def validate_content(data)
      unless data.instance_of?(Hash)
        raise ValidationError, "pages/#{@id}.yml: Page Content File root is not a hash"
      end

      # check for unwanted keys
      unwanted = data.keys - %w(blocks block_containers)
      if unwanted.any?
        msg = "pages/#{@id}.yml: Invalid page content keys were found: #{unwanted.join(', ')}"
        raise ValidationError, msg
      end

      # check for needed keys
      needed = %w(blocks block_containers) - data.keys
      if needed.any?
        msg = "pages/#{@id}.yml: Needed page content keys were not found: #{needed.join(", ")}"
        raise ValidationError, msg
      end

      unless data["blocks"].instance_of?(Hash)
        msg = "pages/#{@id}.yml: Page Content File does not contain a blocks hash"
        raise ValidationError, msg
      end

      unless data["block_containers"].instance_of?(Hash)
        msg = "pages/#{@id}.yml: Page Content File does not contain a block_containers hash"
        raise ValidationError, msg
      end
    end

    def set_special(special)
      @id     = special.to_s
      @layout = special.to_s
      @slug   = special.to_s
    end
  end
end

