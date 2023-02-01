module JekyllBlocker
  class Action::Generate::Page
    Choice = Struct.new(:id, :label)

    def initialize(config)
      @config = config
    end

    def add
      pastel = Pastel.new
      prompt = TTY::Prompt.new
      pages  = PageCollection.new(@config)

      choices = []
      build_choices(pages.all) do |choice|
        choices << choice
      end
      layouts = Dir[File.join(@config.root_path, "_layouts", "*")].map do |file|
        File.basename(file, ".*")
      end

      page = prompt.collect do
        loop do
          uuid = SecureRandom.uuid
          id = key("id").ask("Choose an ID?", default: uuid)

          unless pages.all.key?(id)
            break
          end

          puts pastel.red("The ID '#{id}' already exists, please choose another")
        end

        parent =  key("parent").select("Parent:") do |menu|
                    menu.choice "None", nil

                    choices.each do |choice|
                      menu.choice choice.label, choice.id
                    end
                  end

        key("title").ask("Title:")
        key("description").ask("Description:")

        loop do
          slug = key("slug").ask("Slug:") do |q|
            q.convert -> (input) { input.downcase.gsub(/[^a-z0-9\-_]+/, "-") }
          end
          slugs = pages.all.
            select { |_, page| page.parent == parent }.
            map { |item| item[1].slug }

          unless slugs.include?(slug)
            break
          end

          puts pastel.red("The Slug '#{slug}' is already in use for the parent page, please choose another")
        end

        key("layout").select("Layout", layouts)
      end

      pages.add(page)
      pages.save
      puts "Added Child"
    end

    private

    def build_choices(pages, level=0, parent=nil)
      pages.each do |id, page|
        next if id == 'home' || id == 'not_found'
        if page.parent == parent
          yield Choice.new(page.id, "#{"  " * level}#{page.title}")
          build_choices(pages, level+1, page.id) do |choice|
            yield choice
          end
        end
      end
    end
  end
end

    # id: 1
    # title: Foo
    # layout: page
    # slug: foo
    # description: This is a foo page
    # pages:

