module JekyllBlocker
  class MenuTag < Liquid::Tag
    def initialize(tag_name, params, parse_context)
      super
      parts = params.to_s.strip.split.compact

      if parts.count == 2
        @name  = parts.first.strip
        @style = parts.last.strip
      else
        raise Liquid::SyntaxError, "menu tag expects 2 arguments, #{parts.count} given"
      end
    end

    def render(context)
      @context = context
      @style   = parse_param(@style)
      menu     = build_menu(load_menu(@name))

      if style_wrapper
        menu = render_part(style_wrapper, { "content" => menu })
      end

      menu
    end

    private

    def render_part(content, params)
      _context = Liquid::Context.new(@context.environments.dup, {}, @context.registers)
      params.each {|key, value| _context[key] = value}
      template = Liquid::Template.parse(content)
      template.render(_context)
    end

    def build_menu(menu)
      out = ""
      menu.each do |item|
        url = case item["type"]
              when "page"
                pages = @context.registers[:site].pages
                pages.find{|page| page["id"] == item["value"]}&.url.to_s
              when "text"
                item["value"]
              when "placeholder"
                nil
              end
        data = {
          "classes" => item["classes"].to_s,
          "url" => url,
          "text" => item["text"].to_s
        }
        if item["children"].instance_of?(Array) && item["children"].any?
          data["children"] = build_menu(item["children"])
        end

        out << render_part(style_item, data)
      end
      out
    end

    def parse_param(name)
      if (name[0] == '"' && name[-1] == '"') ||
         (name[0] == "'" && name[-1] == "'")
        name[1..-2]
      else
        part = @context
        name.split(".").each do |value|
          part = part[value]
        end
        part.to_s
      end
    end

    def style_wrapper
      @style_wrapper ||= get_style_part("wrapper", true)
    end

    def style_item
      @style_item ||= get_style_part("item")
    end

    def get_style_part(part, optional=false)
      file_path = File.join("_blocker", "menu_styles", @style, "#{part}.liquid")

      return if optional && !File.exist?(file_path)

      File.read(file_path)
    end

    def load_menu(param)
      name = parse_param(param)
      file_path = File.join("_blocker", "menus", "#{name}.yml")
      YAML.safe_load(File.read(file_path))
    end
  end
end

Liquid::Template.register_tag('menu', JekyllBlocker::MenuTag)

