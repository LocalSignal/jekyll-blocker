# frozen_string_literal: true

# require "debug"

require 'yaml'
require 'uri'
require 'fileutils'
require 'jekyll'
require_relative "jekyll-blocker/version"
require_relative "jekyll-blocker/blocks"
require_relative "jekyll-blocker/block_tag"
require_relative "jekyll-blocker/block_container_tag"
require_relative "jekyll-blocker/redirect_page"
require_relative "jekyll-blocker/virtual_page"
require_relative "jekyll-blocker/pages_generator"
require_relative "jekyll-blocker/blocker_command"
require_relative "jekyll-blocker/blocker_new_action"
require_relative "jekyll-blocker/block_renderer"

module JekyllBlocker
  class ContainsBlockerFolderError < StandardError; end
  class NotJekyllSiteError < StandardError; end
  class BlockParamsError < StandardError; end
  class NamedBlockDoesNotExistError < StandardError; end
  class BlockTypeDataTypeMissmatchError < StandardError; end
  class BlockContainerRequiresNameError < StandardError; end
end

