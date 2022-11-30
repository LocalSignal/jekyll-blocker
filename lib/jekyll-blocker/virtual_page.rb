module JekyllBlocker
  class VirtualPage < Jekyll::Page
    def initialize(site, path, frontmatter)
      @site     = site
      @dir      = path
      @basename = 'index'
      @ext      = '.html'
      @name     = 'index.html'

      @data = frontmatter.instance_of?(Hash) ? frontmatter : {}

      data.default_proc = proc do |_, key|
        site.frontmatter_defaults.find(relative_path, '', key)
      end
    end

    def content
      @content ||= <<~DOC
        {% for blk in page.blocks %}
          {% block blk %}
        {% endfor %}
      DOC
    end
  end
end
