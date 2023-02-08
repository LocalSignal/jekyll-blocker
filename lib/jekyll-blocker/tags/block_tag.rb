module JekyllBlocker
  class BlockTag < Liquid::Tag
    def initialize(tag_name, params, parse_context)
      super
      parts = params.to_s.strip.split.compact

      if parts.count == 1
        @name = @id = parts.first.strip
      elsif parts.count == 2
        @name = parts.first
        @id = parts.last
      else
        raise Liquid::SyntaxError, "block tag expects 1..2 arguments, #{parts.count} given"
      end
    end

    def render(context)
      blocks = context.registers[:site].config["blocks"]
      page_blocks = context.registers[:page]["blocks"] || {}
      block  = page_blocks[@id] || { "type" => @name, "fields" => {} }

      raise BlockerError unless @name == block["type"]

      blocks.find(@name).render(block["fields"])
    end
  end
end

Liquid::Template.register_tag('block', JekyllBlocker::BlockTag)

