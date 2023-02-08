module JekyllBlocker
  class BlockCollection
    def initialize(folder)
      @blocks = {}
      @path = File.join(folder, "_blocker", "blocks")

      paths = Dir[File.join(@path, "**", "*.{html,liquid}")]
      paths.each { |path| load_block(path) }
    end

    def find(name)
      @blocks[name]
    end

    private

    def load_block(path)
      file = Utilities.read_jekyll_file(path)

      key = Pathname(
              path.sub(/\A#{@path}/, '').
                   sub(/#{File.extname(path)}\z/, '')
            ).each_filename.to_a.join('/')

      if @blocks.key? key
        raise ValidationError, "Block '#{key}' exists in multiple extensions"
      end

      @blocks[key] = Block.new(content: file[:content], data: file[:data])
    end
  end
end
