module JekyllBlocker
  class Page
    attr_accessor :id, :title, :description, :layout, :slug, :path

    def initialize(data, config, special: nil, parent: nil)
      errors = []
      @config = config

      set_special(special) if special

      @id ||= data["id"].to_s.strip
      if @id.empty?
        errors << "No id specified for page"
      end

      @layout ||= data["layout"].to_s.strip
      if @layout.empty?
        errors << "No layout specified for page"
      elsif !File.exist?(
              File.expand_path(
                File.join(@config.blocker_path, "..", "_layouts", "#{@layout}.html")))
        errors << "No layout found for page"
      end

      @slug ||= data["slug"].to_s.strip
      if @slug.empty?
        errors << "No slug specified for page"
      end

      if errors.any?
        raise PageError, errors.join("\n")
      end

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

    def set_special(special)
      @id = @layout = @slug = special.to_s
    end
  end
end

