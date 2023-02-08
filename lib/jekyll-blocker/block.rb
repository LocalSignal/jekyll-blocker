module JekyllBlocker
  class Block
    attr_accessor :content, :data

    def initialize(content: "", data: {})
      @content = content.instance_of?(String) ? content : ""
      @data    = data.instance_of?(Hash) ? data : {}
    end

    def render(instance_data, context)
      _context = context.dup

      data.each do |key, value|
        _context[key] = instance_data.key?(key) ? instance_data[key] : value["value"]
      end

      template = Liquid::Template.parse(@content)
      template.render(_context)
    end
  end
end

