module JekyllBlocker
  class BlocksTag < Liquid::Tag
    def initialize(tag_name, info, tokens)
      super
      @info = info.strip
    end

    def render(context)
      ""
    end
  end
end

Liquid::Template.register_tag('blocks', JekyllBlocker::BlocksTag)
