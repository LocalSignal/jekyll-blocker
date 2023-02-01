module JekyllBlocker
  class Action::Generate::Redirect
    def initialize(config)
      @config = config
    end

    def add
      pastel = Pastel.new
      prompt = TTY::Prompt.new
      redirects = RedirectCollection.new(@config)

      redirect = prompt.collect do
        key("from").ask("From")
        key("to").ask("To")
      end

      redirects.add redirect

      puts pastel.cyan("Added: #{redirect["from"]} => #{redirect["to"]}")
    end
  end
end
