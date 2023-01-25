module JekyllBlocker
  Jekyll::Hooks.register :site, :after_init do |site|
    config = Config.new site.source
    site.config["blocker"] = { "config" => config }
  end
  Jekyll::Hooks.register :site, :pre_render do |site, payload|
    blocks = Blocks.new site.config["blocker"]["config"].blocks_path
    payload["blocker_blocks"] = blocks
  end
  Jekyll::Hooks.register :pages, :pre_render do |page, payload|
    payload["page_block_content"] = if page.instance_of?(VirtualPage)
                                      page.block_content
                                    end
  end
end
