module JekyllBlocker
  class Utilities
    class << self
      def read_yaml(path, name)
        file_path = File.join(path, "#{name}.yml")

        unless File.exist?(file_path)
          raise ConfigFileDoesNotExistError, file_path
        end

        YAML.safe_load(File.read(file_path))
      end
    end
  end
end

