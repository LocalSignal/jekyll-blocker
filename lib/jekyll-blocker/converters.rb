module JekyllBlocker
  class LiquidConverter < Jekyll::Converter
    safe true
    priority :low

    def matches(ext)
      ext =~ /^\.liquid$/i
    end

    def output_ext(ext)
      ".html"
    end

    def convert(content)
      content
    end
  end
end
