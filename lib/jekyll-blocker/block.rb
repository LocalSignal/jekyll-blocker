module JekyllBlocker
  class BlockTag < Liquid::Tag
    class << self
      def set_blocks(site)
        @blocks = begin
          blocks = {}
          blocks_path = File.join(site.source, "_blocks")
          blocks_glob = File.join(blocks_path, "**", "*.html")
          block_paths = Dir[blocks_glob]
          block_paths.each do |path|
            id  = path.sub(/\.html\z/, '').sub(/\A#{blocks_path}#{File::SEPARATOR}/, '')
            blocks[id] = read_block(path)
          end
          blocks
        end
      end

      def blocks
        @blocks
      end

      def read_block(path)
        data = {}
        content = File.read(path)

        if content =~ Jekyll::Document::YAML_FRONT_MATTER_REGEXP
          content = Regexp.last_match.post_match
          data = YAML.safe_load(Regexp.last_match(1))
        end

        { "content" => content, "data" => data }
      end
    end

    def initialize(tag_name, info, tokens)
      super
      @info = info.strip
    end

    def render(context)
      cxt   = context.dup
      info  = cxt[@info]
      block = BlockTag.blocks[info["id"]]

      if info["fields"]
        info["fields"].each do |key, value|
          cxt[key] = value
        end
      end

      template = Liquid::Template.parse(block["content"])
      template.render(cxt)
    end
  end
end

Liquid::Template.register_tag('block', JekyllBlocker::BlockTag)
