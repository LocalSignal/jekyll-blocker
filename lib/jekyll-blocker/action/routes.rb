module JekyllBlocker
  class Action::Routes < Action
    def run
      super

      pages = [["ID", "PATH"]]
      collection = PageCollection.new(@config)

      collection.all.each do |_, page|
        pages << [page.frontmatter["blocker_page_id"], page.path]
      end

      puts TTY::Table.new(pages).render(:basic, alignments: [:right, :left])
    end
  end
end
