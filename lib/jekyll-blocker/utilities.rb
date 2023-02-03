module JekyllBlocker
  class Utilities
    class << self
      def read_jekyll_file(path)
        out = { data: {}, content: File.read(path) }

        if out[:content] =~ Jekyll::Document::YAML_FRONT_MATTER_REGEXP
          out[:content] = Regexp.last_match.post_match
          out[:data] = YAML.safe_load(Regexp.last_match(1))
        end

        out
      end

      def final_message(error=nil)
        pastel = Pastel.new

        msg = if error
                error.message
              else
                "Successfully completed blocker build"
              end

        msg = <<~MESSAGE

          #{"-" * TTY::Screen.width}
          #{msg}
          #{"-" * TTY::Screen.width}
        MESSAGE

        if error
          pastel.red(msg)
        else
          pastel.green(msg)
        end
      end
    end
  end
end

