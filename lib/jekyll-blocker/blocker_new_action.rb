module JekyllBlocker
  class BlockerNewAction
    def initialize(folder)
      @folder  = folder
    end

    def run
      raise ContainsBlockerFolderError if Dir.exist?(blocker_path)
      raise NotJekyllSiteError unless File.exist?(File.join(@folder, "_config.yml")) &&
                                 File.exist?(File.join(@folder, "Gemfile"))

      blocks_path = File.join(blocker_path, "blocks")
      FileUtils.mkdir_p(blocks_path)
      FileUtils.touch(File.join(blocks_path, ".keep"))

      config_path = File.join(blocker_path, "config")
      FileUtils.mkdir_p(config_path)
      File.write(File.join(config_path, "pages.yml"), pages_yml)
      FileUtils.touch(File.join(config_path, "redirects.yml"))

      pages_path = File.join(blocker_path, "pages")
      FileUtils.mkdir_p(pages_path)
      File.write(File.join(pages_path, "home.yml"), empty_page_yml)
      File.write(File.join(pages_path, "not_found.yml"), empty_page_yml)
    end

    private

    def blocker_path
      @blocker_path ||= File.join(@folder, "_blocker")
    end

    def pages_yml
      <<~HERE
        title: Home Page
        description: Home Page
        not_found:
          title: Page Not Found
          description: Page Not Found
        pages: []
      HERE
    end

    def empty_page_yml
      <<~HERE
        blocks: {}
        block_containers: {}
      HERE
    end
  end
end
