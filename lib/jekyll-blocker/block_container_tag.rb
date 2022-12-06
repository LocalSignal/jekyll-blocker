module JekyllBlocker
  class BlockContainerTag < Liquid::Block
    def initialize(tag_name, info, tokens)
      super
      parts = info.to_s.strip.split.compact
      if parts.count >= 1
        @name = parts.first
      else
        raise BlockContainerRequiresNameError
      end
    end

    def render(context)
      blocks = context.registers.dig(:page, "cms", "block_containers", @name)

      out = ""
      blocks.each do |block|
        out << BlockRenderer.new(block["block"], block["fields"]).render
      end
      out
    end
  end
end

Liquid::Template.register_tag('block_container', JekyllBlocker::BlockContainerTag)

