module JekyllBlocker
  class PagesGenerator < Jekyll::Generator
    safe true

    def generate(site)
      config = Config.new site.source
      blocks = Blocks.new config.blocks_path

      Jekyll::Hooks.register :site, :pre_render do |site, payload|
        payload["blocker"] = { "config" => config, "blocks" => blocks }
      end
      Jekyll::Hooks.register :pages, :pre_render do |page, payload|
        payload["page_block_content"] = if page.instance_of?(VirtualPage)
                                          page.block_content
                                        end
      end

      PageCollection.new(config).all.each do |_, page|
        site.pages << VirtualPage.new(site, page)
      end
      RedirectCollection.new(config).all.each do |redirect|
        site.pages << RedirectPage.new(site, redirect)
      end
    end
  end
end
