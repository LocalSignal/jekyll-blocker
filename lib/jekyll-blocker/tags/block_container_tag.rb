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
      blocks          = context.registers[:site].config["blocks"]
      block_container = context.registers.dig(:page, "block_containers", @name) ||
                        super.split.map do |block|
                          { "type" => block, "fields" => {} }
                        end

      out = ""
      block_container.each do |block|
        out << blocks.find(block["type"]).render(block["fields"])
      end
      out
    end
  end
end

Liquid::Template.register_tag('block_container', JekyllBlocker::BlockContainerTag)

