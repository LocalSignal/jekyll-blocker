module JekyllBlocker
  class Block
    attr_accessor :content, :data

    ALLOWED_TAGS = %w(assign break capture case comment continue cycle decrement
                      for if ifchanged increment raw tablerow unless highlight
                      link post_url)

    def initialize(content: "", data: {})
      @content = content.instance_of?(String) ? content : ""
      @data    = data.instance_of?(Hash) ? data : {}
    end

    def render(instance_data, context)
      _context = Liquid::Context.new(context.environments.dup, {}, context.registers)

      data.each do |key, value|
        temp = instance_data.key?(key) ? instance_data[key] : value["value"]
        case value["type"]
        when "text", "richtext", "html"
          essential_liquid_tags do
            temp = Liquid::Template.parse(temp).render(context)
          end
        when "image"
          temp['src'] = '/uploads/images/' + temp['src']
        when "file"
          temp = '/uploads/files/' + temp
        when "markdown"
          essential_liquid_tags do
            temp = Liquid::Template.parse(temp).render(context)
          end
          temp = Kramdown::Document.new(temp, input: 'GFM').to_html
        end
        _context[key] = temp
      end

      template = Liquid::Template.parse(@content)
      template.render(_context)
    end

    private

    def essential_liquid_tags
      removed = {}
      Liquid::Template.tags.each do |name, klass|
        unless ALLOWED_TAGS.include?(name)
          removed[name] = klass
          Liquid::Template.tags.delete(name)
        end
      end
      yield
      removed.each do |name, klass|
        Liquid::Template.register_tag(name, Object.const_get(klass))
      end
    end
  end
end

