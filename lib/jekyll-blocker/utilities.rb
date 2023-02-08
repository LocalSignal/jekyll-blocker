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
    end
  end
end

