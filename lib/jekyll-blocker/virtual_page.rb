module JekyllBlocker
  class VirtualPage < Jekyll::Page
    def initialize(site, path, frontmatter, cms)
      @site     = site
      @dir      = path
      @basename = 'index'
      @ext      = '.html'
      @name     = 'index.html'

      @data = frontmatter.instance_of?(Hash) ? frontmatter : {}
      @data["cms"] = cms

      data.default_proc = proc do |_, key|
        site.frontmatter_defaults.find(relative_path, '', key)
      end
    end
  end
end
