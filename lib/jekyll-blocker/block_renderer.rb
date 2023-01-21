module JekyllBlocker
  class BlockRenderer
    def initialize(block, content)
      @block = block
      @content = content
    end

    def render
      raise NamedBlockDoesNotExistError unless @block

      data = {}

      @block.data.each do |key, value|
        data[key] = @content.key?(key) ? @content[key] : value["value"]
      end

      template = Liquid::Template.parse(@block.content)
      template.render(data)
    end
  end
end
