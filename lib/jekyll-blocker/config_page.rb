module JekyllBlocker
  class ConfigPage
    attr_accessor :id, :title, :description, :layout, :slug, :parent

    def initialize(data, special: nil, parent: nil)
      errors = []
      @pages_path = File.join(ConfigPages.blocker_path, "pages")

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
                File.join(ConfigPages.blocker_path, "..", "_layouts", "#{@layout}.html")))
        errors << "No layout found for page"
      end

      @slug ||= data["slug"].to_s.strip
      if @slug.empty?
        errors << "No slug specified for page"
      end

      if errors.any?
        raise ConfigPageError.new(errors)
      end

      @title       = data["title"].to_s.strip
      @description = data["description"].to_s.strip
      @parent      = parent&.id
    end

    def frontmatter
      {
        "id" => @id,
        "slug" => @slug,
        "layout" => @layout,
        "title" => @title,
        "description" => @description,
      }
    end

    def content
      @content ||= begin
                     file_path = File.join("_blocker", "pages", @id + ".yml")
                     data = Utilities.read_yaml(@pages_path, @id)
                     unless data.instance_of?(Hash)
                       raise PageFileError, "Page Content File is not a hash: #{file_path}"
                     end
                     unless data["blocks"].instance_of?(Hash)
                       raise PageFileError, "Page Content File does not contain a blocks hash: #{file_path}"
                     end
                     unless data["block_containers"].instance_of?(Hash)
                       raise PageFileError, "Page Content File does not contain a block_containers hash: #{file_path}"
                     end
                     data
                   end
    end

    def path(pages)
      case @id
      when "home"
        "/"
      when "not_found"
        "/404"
      else
        parts = [@slug]
        parent_id = @parent

        while parent_id
          parts << pages[parent_id].slug
          parent_id = pages[parent_id].parent
        end

        "/" << parts.reverse.join("/")
      end
    end

    private

    def set_special(special)
      @id = @layout = @slug = special.to_s
    end
  end
end

