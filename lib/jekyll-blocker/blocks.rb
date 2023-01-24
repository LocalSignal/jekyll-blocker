module JekyllBlocker
  class Blocks
    def initialize(path)
      @blocks = {}
      @path = path
      glob = File.join(path, "**", "*.{html,liquid}")
      paths = Dir[glob]
      paths.each { |path| load_block(path) }
    end

    def find(name)
      @blocks[name]
    end

    private

    def load_block(path)
      data = {}
      content = File.read(path)

      if content =~ Jekyll::Document::YAML_FRONT_MATTER_REGEXP
        content = Regexp.last_match.post_match
        data = YAML.safe_load(Regexp.last_match(1))
      end

      key = Pathname(
              path.sub(/\A#{@path}/, '').
                   sub(/#{File.extname(path)}\z/, '')
            ).each_filename.to_a.join('/')

      if @blocks.key? key
        raise BlocksError, "Block '#{key}' exists in multiple extensions"
      end

      @blocks[key] = Block.new(content: content, data: data)
    end
  end
end
