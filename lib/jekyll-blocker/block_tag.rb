module JekyllBlocker
  class BlockTag < Liquid::Tag
    def initialize(tag_name, params, parse_context)
      super
      parts = params.to_s.strip.split.compact

      if parts.count == 1
        @name = parts.first
        @id = parts.first
      elsif parts.count == 2
        @name = parts.first
        @id = parts.last
      else
        raise Liquid::SyntaxError, "block tag expects 1..2 arguments, #{parts.count} given"
      end
    end

    def render(context)
      blocks = context.environments.first["blocker_blocks"]
      block  = context.environments.first["page_block_content"].dig("blocks", @id)

      return "" unless block.instance_of?(Hash)
      raise BlockTypeDataTypeMissmatchError unless @name == block["block"]

      BlockRenderer.new(blocks.find(@name), block["fields"]).render
    end
  end
end

Liquid::Template.register_tag('block', JekyllBlocker::BlockTag)

