module JekyllBlocker
  class PagesGenerator < Jekyll::Generator
    safe true

    def blocker_path
      @pages_path ||= File.join(@site.source, "_blocker")
    end

    def config_path
      @config_path ||= File.join(@site.source, "_blocker", "config")
    end

    def generate(site)
      Blocks.set_blocks(site.source)
      @site = site

      build_pages
      build_redirects
    end

    def build_pages
      pages_config = JekyllBlocker::ConfigPages.load(blocker_path)
      pages_config.pages.each do |_, page|
        @site.pages << VirtualPage.new(
                        @site,
                        page.path(pages_config.pages),
                        page.frontmatter,
                        page.content
                      )
      end
    end

    def build_redirects
      redirects = Utilities.read_yaml(config_path, "redirects")
      return unless redirects.instance_of?(Array)

      redirects.each do |redirect|
        @site.pages << RedirectPage.new(site, redirect["from"], redirect["to"])
      end
    rescue ConfigFileDoesNotExistError
      puts "Warning: Redirects file does not exist!"
    end
  end
end
