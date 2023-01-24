module JekyllBlocker
  class PageCollection
    attr_reader :pages
    alias all pages

    def initialize(config)
      @config = config
      @pages = {}
      data = Utilities.read_yaml(config.config_path, "pages")

      @pages["home"] = Page.new(data, config, special: :home)
      @pages["not_found"] = Page.new(data["not_found"], config, special: :not_found)

      build_pages(data["pages"], nil) do |page|
        @pages[page.id] = page
      end
    end

    def find(id)
      @pages[id.to_s]
    end

    private

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
  end
end

