# frozen_string_literal: true

# require "debug"

require 'yaml'
require 'uri'
require 'fileutils'
require 'jekyll'
require 'tty-table'
require_relative "jekyll-blocker/version"
require_relative "jekyll-blocker/blocks"
require_relative "jekyll-blocker/block_tag"
require_relative "jekyll-blocker/block_container_tag"
require_relative "jekyll-blocker/redirect_page"
require_relative "jekyll-blocker/virtual_page"
require_relative "jekyll-blocker/pages_generator"
require_relative "jekyll-blocker/blocker_command"
require_relative "jekyll-blocker/blocker_new_action"
require_relative "jekyll-blocker/blocker_show_pages_action"
require_relative "jekyll-blocker/block_renderer"
require_relative "jekyll-blocker/config_pages"
require_relative "jekyll-blocker/config_page"
require_relative "jekyll-blocker/utilities"

module JekyllBlocker
  class ContainsBlockerFolderError < StandardError; end
  class NotJekyllSiteError < StandardError; end
  class BlockParamsError < StandardError; end
  class NamedBlockDoesNotExistError < StandardError
    def initialize(msg="Block does not exist")
      super
    end
  end
  class BlockTypeDataTypeMissmatchError < StandardError; end
  class BlockContainerRequiresNameError < StandardError; end
  class ConfigFileDoesNotExistError < StandardError
    def initialize(msg="")
      super "Missing config file: " + msg
    end
  end
  class PageFileError < StandardError
    def initialize(msg="Page Content File Error")
      super
    end
  end
  class ConfigPageError < StandardError
    attr_reader :errors
    def initialize(errors=[])
      @errors = errors
      super("An error has occurred with a page in the pages config.")
    end
  end
end

