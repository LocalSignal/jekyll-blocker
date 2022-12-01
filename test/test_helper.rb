# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "jekyll-blocker"
require "minitest/autorun"

FileUtils.rm_rf(File.expand_path("tmp"))
