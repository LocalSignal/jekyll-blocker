module JekyllBlocker
  class ActionNew < Action
    def run
      super

      raise ContainsBlockerFolderError if Dir.exist?(@config.blocker_path)

      FileUtils.mkdir_p(@config.blocks_path)
      FileUtils.touch(File.join(@config.blocks_path, ".keep"))

      FileUtils.mkdir_p(@config.config_path)
      File.write(File.join(@config.config_path, "pages.yml"), pages_yml)
      FileUtils.touch(File.join(@config.config_path, "redirects.yml"))

      FileUtils.mkdir_p(@config.pages_path)
      File.write(File.join(@config.pages_path, "home.yml"), empty_page_yml)
      File.write(File.join(@config.pages_path, "not_found.yml"), empty_page_yml)
    end

    private

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
