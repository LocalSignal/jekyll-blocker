module JekyllBlocker
  class Blocks
    class << self
      def set_blocks(path)
        @blocks = {}
        glob = File.join(path, "_blocker", "blocks", "*.html")
        paths = Dir[glob]
        paths.each { |path| load_block(path) }
      end

      def find(name)
        @blocks[name]
      end

      def load_block(path)
        data = {}
        content = File.read(path)

        if content =~ Jekyll::Document::YAML_FRONT_MATTER_REGEXP
          content = Regexp.last_match.post_match
          data = YAML.safe_load(Regexp.last_match(1))
        end

        @blocks[File.basename(path, ".*")] = { "content" => content, "data" => data }
      end
    end
  end
end
