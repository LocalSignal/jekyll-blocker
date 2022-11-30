# frozen_string_literal: true

require 'yaml'
require 'uri'
require_relative "jekyll-blocker/version"
require_relative "jekyll-blocker/block"
require_relative "jekyll-blocker/redirect_page"
require_relative "jekyll-blocker/virtual_page"
require_relative "jekyll-blocker/pages_generator"

module JekyllBlocker
  class Error < StandardError; end
end

