module JekyllBlocker
  class BlockRenderer
    def initialize(name, content)
      @name = name
      @content = content
    end

    def render
      block = Blocks.find(@name)
      raise NamedBlockDoesNotExistError unless block

      data = {}

      block["data"].each do |key, value|
        data[key] = @content.key?(key) ? @content[key] : value["value"]
      end

      template = Liquid::Template.parse(block["content"])
      template.render(data)
    end
  end
end
