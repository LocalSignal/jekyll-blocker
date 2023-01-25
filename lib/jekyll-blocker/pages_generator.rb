module JekyllBlocker
  class PagesGenerator < Jekyll::Generator
    safe true
    priority :lowest

    def generate(site)
      error  = nil
      config = site.config["blocker"]["config"]

      PageCollection.new(config).all.each do |_, page|
        site.pages << VirtualPage.new(site, page)
      end
      RedirectCollection.new(config).all.each do |redirect|
        site.pages << RedirectPage.new(site, redirect)
      end
      puts Utilities.final_message
    rescue ValidationError => e
      puts Utilities.final_message e
    end
  end
end
