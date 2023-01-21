module JekyllBlocker
  class Block
    attr_accessor :content, :data

    def initialize(content: "", data: {})
      @content = content if content.instance_of?(String)
      @data = data if data.instance_of?(Hash)
    end

    def render(instance_data)
      _data = {}

      data.each do |key, value|
        _data[key] = instance_data.key?(key) ? instance_data[key] : value["value"]
      end

      template = Liquid::Template.parse(content)
      template.render(_data)
    end
  end
end

