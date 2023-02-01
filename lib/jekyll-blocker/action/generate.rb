module JekyllBlocker
  class Action::Generate < Action
    def run(args, options)
      super
      prompt = TTY::Prompt.new

      case prompt.select("What are we creating?", %w(page redirect block))
      when "page"
        Action::Generate::Page.new(@config).add
      when "redirect"
        Action::Generate::Redirect.new(@config).add
      when "block"
      end
    end

    private

    def valid_doc_type?(doc_type)
      %w(page).include?(doc_type)
    end
  end
end
