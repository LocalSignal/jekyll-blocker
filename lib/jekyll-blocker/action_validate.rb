module JekyllBlocker
  class ActionValidate < Action
    def run
      super

      Config.set_root_path
      errors = Validator.analyze do
                 pages_config
               end

      puts errors.any? ? errors : "No errors found"
    end
  end
end
