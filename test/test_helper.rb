# frozen_string_literal: true

$VERBOSE=nil

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "jekyll-blocker"
require "minitest/autorun"

FileUtils.rm_rf(File.expand_path("tmp"))

def site_path
  @site_path ||= File.expand_path(File.join("test", "site"))
end

def run_in_tmp_folder
  tmp_path = File.expand_path(File.join("tmp", SecureRandom.uuid))
  FileUtils.mkdir_p(tmp_path)
  config   = JekyllBlocker::Config.new tmp_path
  yield config
  FileUtils.rm_rf(tmp_path)
end

def set_pages_yml(config, data)
  FileUtils.mkdir_p(config.config_path)
  pages_yml = File.join(config.config_path, "pages.yml")
  File.open(pages_yml, "w") { |file| file.write(data.to_yaml) }
end

