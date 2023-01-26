module JekyllBlocker
  class BlockContainerTag < Liquid::Block
    def initialize(tag_name, params, parse_context)
      super
      parts = params.to_s.strip.split.compact
      if parts.count == 1
        @name = parts.first
      else
        msg = "block_container tag expects 1 argument, #{parts.count} given"
        raise Liquid::SyntaxError, msg
      end
    end

    def render(context)
      env = context.environments.first
      blocks = env["blocker_blocks"]
      block_container = env["page_block_content"].
                        dig("block_containers", @name)

      out = ""
      block_container.each do |block|
        begin
          out << BlockRenderer.new(blocks.find(block["block"]), block["fields"]).render
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

