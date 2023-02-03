module JekyllBlocker
  Jekyll::Hooks.register :site, :pre_render do |site, payload|
    site.config["blocks"] = BlockCollection.new(site.source)
  end
end
