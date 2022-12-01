# frozen_string_literal: true

require 'yaml'
require 'uri'
require 'fileutils'
require 'jekyll'
require_relative "jekyll-blocker/version"
require_relative "jekyll-blocker/block"
require_relative "jekyll-blocker/redirect_page"
require_relative "jekyll-blocker/virtual_page"
require_relative "jekyll-blocker/pages_generator"
require_relative "jekyll-blocker/blocker_command"
require_relative "jekyll-blocker/blocker_new_action"

module JekyllBlocker
  class Error < StandardError; end
  class ContainsBlockerFolder < StandardError; end
  class NotJekyllSite < StandardError; end
end

