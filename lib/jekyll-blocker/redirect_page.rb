module JekyllBlocker
  class RedirectPage < Jekyll::Page
    def initialize(site, from, to)
      @site        = site
      @redirect_to = to
      @data = {"layout" => nil}

      path = URI.parse(from).path
      path.sub!(/\/+\z/, '')

      if path =~ /\.[0-9a-zA-Z]+/
        split     = path.rpartition('/')
        @dir      = split.first
        @basename = File.basename(split.last, ".*")
        @ext      = File.extname(split.last)
        @name     = split.last
        @data["permalink"] = path
      else
        @dir      = from
        @basename = 'index'
        @ext      = '.html'
        @name     = 'index.html'
      end
    end

    def content
      @content ||= <<~DOC
        <!DOCTYPE html>
        <html>
          <head>
            <meta http-equiv="content-type" content="text/html; charset=utf-8" />
            <meta http-equiv="refresh" content="0;url=#{@redirect_to}" />
          </head>
        </html>
      DOC
    end
  end
end

