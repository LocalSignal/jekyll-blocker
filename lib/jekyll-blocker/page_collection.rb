module JekyllBlocker
  class PageCollection
    attr_reader :pages, :data
    alias all pages

    def initialize(config)
      data = Utilities.read_yaml(config.config_path, "pages")
      validate(data)

      @config = config
      @pages  = {}
      @data   = data

      @pages["home"] = Page.new(data["home"], config, special: :home)
      @pages["not_found"] = Page.new(data["not_found"], config, special: :not_found)

      build_pages(data["pages"], nil) do |page|
        if @pages.key? page.id
          msg = "config/pages.yml: Duplicate page ids found: #{page.id}"
          raise ValidationError, msg
        end
        @pages[page.id] = page
      end
    end

    def find(id)
      @pages[id.to_s]
    end

    def add(params)
      page = Page.new(params, @config)
      if @pages.key? page.id
        msg = "config/pages.yml: Page id already exists: #{page.id}"
        raise ValidationError, msg
      end
      @pages[page.id] = page
    end

    def save
      path = File.join(@config.config_path, "pages.yml")
      File.open(path, "w") do |f|
        f.write self.to_yaml.gsub(/\A---/, '').strip
      end

      page_content_files = Dir[File.join(@config.pages_path, "*.yml")].
                             map{|file| File.basename(file, ".*")}

      (@pages.keys - page_content_files).each do |file|
        File.open(File.join(@config.pages_path, "#{file}.yml"), "w") do |f|
          f.write "blocks: {}\nblock_containers: {}"
        end
      end
    end

    def to_yaml
      {
        "home" => @pages["home"].to_h,
        "not_found" => @pages["not_found"].to_h,
        "pages" => structure_pages(@pages.values)
      }.to_yaml
    end

    private

    def structure_pages(items, parent=nil)
      group = items.select do |page|
        page.id != 'home' &&
        page.id != 'not_found' &&
        page.parent == parent
      end.map(&:to_h)

      group.each do |data|
        sub_group = structure_pages(items, data["id"])
        data["pages"] = sub_group if sub_group.any?
      end

      group
    end

    def build_pages(_pages, parent)
      _pages.each do |page|
        config_page = Page.new(page, @config, parent: parent)
        yield config_page

        if page["pages"].instance_of?(Array)
          build_pages(page["pages"], config_page) do |_page|
            yield _page
          end
        end
      end
    end

    def validate(data)
      unless data.instance_of? Hash
        raise ValidationError, "config/pages.yml: Root of file must be a hash"
      end

      # check for unwanted keys
      unwanted = data.keys - %w(home not_found pages)
      if unwanted.any?
        msg = "config/pages.yml: Invalid root keys were found: #{unwanted.join(', ')}"
        raise ValidationError, msg
      end

      # check for needed keys
      needed = %w(home not_found) - data.keys
      if needed.any?
        msg = "config/pages.yml: Required root keys were not found: #{needed.join(", ")}"
        raise ValidationError, msg
      end

      if !data["pages"].nil? && !data["pages"].instance_of?(Array)
        msg = "config/pages.yml: Root pages key must be an array"
        raise ValidationError, msg
      end
    end
  end
end

