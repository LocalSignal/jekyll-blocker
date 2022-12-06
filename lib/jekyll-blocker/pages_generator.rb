module JekyllBlocker
  class PagesGenerator < Jekyll::Generator
    safe true
    attr_reader :site

    def config_path
      @config_path ||= File.join(site.source, "_blocker", "config")
    end

    def pages_path
      @pages_path ||= File.join(site.source, "_blocker", "pages")
    end

    def generate(_site)
      Blocks.set_blocks(_site.source)
      @site = _site
      pages = read_yaml(config_path, "pages")

      frontmatter = clean_frontmatter(pages, layout: "home")
      blocks = read_yaml(pages_path, "home")
      site.pages << VirtualPage.new(site, '/', frontmatter, blocks)

      frontmatter = clean_frontmatter(pages["not_found"], layout: "not_found")
      blocks = read_yaml(pages_path, "not_found")
      site.pages << VirtualPage.new(site, '/404', frontmatter, blocks)

      build_pages(pages["pages"], "")

      redirects = read_yaml(config_path, "redirects")
      return unless redirects

      redirects.each do |redirect|
        site.pages << RedirectPage.new(site, redirect["from"], redirect["to"])
      end
    end

    def read_yaml(path, id)
      YAML.safe_load(
        File.read(
          File.join(path, "#{id}.yml")))
    end

    def clean_frontmatter(info, layout:)
      data = info.select{|key, value| allowed_keys.include?(key)}
      data["layout"] = layout if layout
      data
    end

    def allowed_keys
      @allowed_keys ||= %w(id title layout slug description)
    end

    def build_pages(pages, base_path)
      pages.each do |page|
        frontmatter = clean_frontmatter(page)
        blocks = read_yaml(pages_path, page["id"])
        path = "#{base_path}/#{frontmatter["slug"]}"
        site.pages << VirtualPage.new(site, path, frontmatter, blocks)
        if page["pages"].instance_of?(Array)
          build_pages(site, path, page["pages"])
        end
      end
    end
  end
end
