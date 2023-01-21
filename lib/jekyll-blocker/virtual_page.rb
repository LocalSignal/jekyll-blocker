module JekyllBlocker
  class VirtualPage < Jekyll::Page
    attr_accessor :block_content

    def initialize(site, page)
      @site     = site
      @dir      = page.path
      @basename = 'index'
      @ext      = '.html'
      @name     = 'index.html'

      @data          = page.frontmatter.instance_of?(Hash) ? page.frontmatter : {}
      @block_content = page.block_content.instance_of?(Hash) ? page.block_content : {}

      data.default_proc = proc do |_, key|
        site.frontmatter_defaults.find(relative_path, '', key)
      end
    end
  end
end
