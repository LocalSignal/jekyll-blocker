module JekyllBlocker
  Jekyll::Hooks.register :site, :pre_render do |site, payload|
    # set blocks in config
    site.config["blocks"] = BlockCollection.new(site.source)

    # set site globals
    site.config["globals"] = {}
    global_path = File.join(site.source, "_globals.yml")
    if File.exist? global_path
      globals = YAML.safe_load(File.read(global_path))
      site.config["globals"] = globals.map{|k, v| [k, v["value"]]}.to_h
    end

    # set layout globals
    site.layouts.each do |_, layout|
      layout.data["globals"] = if layout.data["globals"]
                                 layout.data["globals"].
                                   map{|k, v| [k, v["value"]]}.
                                   to_h
                               else
                                 {}
                               end
    end
  end
  Jekyll::Hooks.register :pages, :pre_render do |page, payload|
    # set globals merged data, site and layout
    payload["globals"] = page.site.config["globals"]

    layout = page.site.layouts[page["layout"]]
    if layout
      payload["globals"].merge!(layout.data["globals"])
    end
  end
  Jekyll::Hooks.register :posts, :pre_render do |post, payload|
    # set globals merged data, site and layout
    layout = post.site.layouts[post["layout"]]
    payload["globals"] = post.site.config["globals"].merge(layout.data["globals"])
  end
end
