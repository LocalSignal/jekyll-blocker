module JekyllBlocker
  class PageCollection
    attr_reader :pages

    def initialize(path)
      paths = Dir[File.join(path, "**", "*.{liquid,html}")].reject do |file|
        file =~ /\A#{File.join(path, '_')}/
      end

      paths.each do |path|
        key = file.sub(/\A#{path}/, '')
        file = Utilities.read_jekyll_file(path)
        @pages[key] = Page.new
      end

      binding.break
    end

    def find(id)
      @pages[id.to_s]
    end
  end
end

