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
      blocks = context.registers.dig(:page, "block_content", "block_containers", @name)

      out = ""
      blocks.each do |block|
        begin
          out << BlockRenderer.new(block["block"], block["fields"]).render
        rescue NamedBlockDoesNotExistError
          id = context.registers.dig(:page, "blocker_page_id")
          message = "Block '#{block["block"]}' does not exist in page '#{id}'"
          raise NamedBlockDoesNotExistError, message
        end
      end
      out
    end
  end
end

Liquid::Template.register_tag('block_container', JekyllBlocker::BlockContainerTag)

