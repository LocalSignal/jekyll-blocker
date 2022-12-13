module JekyllBlocker
  class BlockTag < Liquid::Tag
    def initialize(tag_name, info, tokens)
      super
      parts = info.to_s.strip.split.compact

      if parts.count == 1
        @name = parts.first
        @id = parts.first
      elsif parts.count == 2
        @name = parts.first
        @id = parts.last
      else
        raise BlockParamsError
      end
    end

    def render(context)
      page = context.registers.dig(:page, "block_content", "blocks", @id)

      return "" unless page.instance_of?(Hash)
      raise BlockTypeDataTypeMissmatchError unless @name == page["block"]

      BlockRenderer.new(@name, page["fields"]).render
    end
  end
end

Liquid::Template.register_tag('block', JekyllBlocker::BlockTag)

