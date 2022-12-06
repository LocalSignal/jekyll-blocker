# frozen_string_literal: true

$VERBOSE=nil

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "jekyll-blocker"
require "minitest/autorun"

FileUtils.rm_rf(File.expand_path("tmp"))

def site_path
  @site_path ||= File.expand_path(File.join("test", "site"))
end

JekyllBlocker::Blocks.set_blocks(site_path)
