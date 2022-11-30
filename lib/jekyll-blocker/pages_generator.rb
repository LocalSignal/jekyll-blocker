module JekyllBlocker
  class PagesGenerator < Jekyll::Generator
    safe true

    def generate(site)
      BlockTag.set_blocks(site)

      @pages_path = File.join(site.source, "_pages")
      pages = read_yaml("pages")

      # site.pages.select!{|page| page.path =~ /\Aassets#{File::SEPARATOR}/}

      data = get_data(pages["home"])
      site.pages << VirtualPage.new(site, '/', data)

      data = get_data(pages["not_found"])
      site.pages << VirtualPage.new(site, '/404', data)

      build_pages(site, "", pages["pages"])

      redirects = read_yaml("redirects")
      redirects.each do |redirect|
        site.pages << RedirectPage.new(site, redirect["from"], redirect["to"])
      end
    end

    def get_data(info)
      data = info.reject {|key, value| key == "pages"}
      data["blocks"] = read_yaml(data["id"])
      data
    end

    def read_yaml(id)
      file_path = File.join(@pages_path, "#{id}.yml")
      data = File.read(file_path)
      YAML.safe_load(data)
    end

    def build_pages(site, base_path, pages)
      pages.each do |page|
        data = get_data(page)
        path = "#{base_path}/#{data["slug"]}"
        site.pages << VirtualPage.new(site, path, data)
        if page["pages"].instance_of?(Array)
          build_pages(site, path, page["pages"])
        end
      end
    end
  end
end
