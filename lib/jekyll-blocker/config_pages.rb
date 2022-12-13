module JekyllBlocker
  class ConfigPages
    attr_reader :pages

    class << self
      attr_accessor :blocker_path

      def load(blocker_path)
        ConfigPages.new(blocker_path)
      end
    end

    def initialize(blocker_path)
      @pages = {}
      @config_path = File.join(blocker_path, "config")
      data = Utilities.read_yaml(@config_path, "pages")

      ConfigPages.blocker_path = blocker_path

      @pages["home"] = ConfigPage.new(data, special: :home)
      @pages["not_found"] = ConfigPage.new(data["not_found"], special: :not_found)

      build_pages(data["pages"], nil) do |page|
        @pages[page.id] = page
      end
    end

    def find(id)
      @pages[id.to_s]
    end

    # def slugs
    #   pages.map{ |key, value| [key, value.slug] }.to_h
    # end

    private

    def build_pages(_pages, parent)
      _pages.each do |page|
        config_page = ConfigPage.new(page, parent: parent)
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

