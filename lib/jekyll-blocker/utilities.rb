module JekyllBlocker
  class Utilities
    class << self
      def read_yaml(path, name)
        file_path = File.join(path, "#{name}.yml")

        unless File.exist?(file_path)
          message = "YAML file does not exist\n#{file_path}"
          raise ValidationError, message
        end

        YAML.safe_load(File.read(file_path))
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

