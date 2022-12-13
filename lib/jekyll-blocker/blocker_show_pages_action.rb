module JekyllBlocker
  class BlockerShowPagesAction
    def initialize(folder)
      @folder  = folder
    end

    def run
      raise NotJekyllSiteError unless File.exist?(File.join(@folder, "_config.yml")) &&
                                 File.exist?(File.join(@folder, "Gemfile"))

      pages = [["ID", "PATH"]]
      pages_config = ConfigPages.load(blocker_path)
      pages_config.pages.each do |_, page|
        pages << [page.frontmatter["blocker_page_id"], page.path(pages_config.pages)]
      end

      puts TTY::Table.new(pages).render(:basic, alignments: [:right, :left])
    end

    private

    def blocker_path
      @blocker_path ||= File.join(@folder, "_blocker")
    end
  end
end
