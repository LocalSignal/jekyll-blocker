module JekyllBlocker
  BlockContainerRequiresNameError = Class.new(::StandardError)
  BlockParamsError                = Class.new(::StandardError)
  BlockTypeDataTypeMissmatchError = Class.new(::StandardError)
  ContainsBlockerFolderError      = Class.new(::StandardError)
  PageError                       = Class.new(::StandardError)
  PageFileError                   = Class.new(::StandardError)
  NamedBlockDoesNotExistError     = Class.new(::StandardError)
  NotJekyllSiteError              = Class.new(::StandardError)

  ConfigError                     = Class.new(::StandardError)
  ValidationError                 = Class.new(::StandardError)
end
