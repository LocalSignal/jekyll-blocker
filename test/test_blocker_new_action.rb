# frozen_string_literal: true

require "test_helper"
require "securerandom"

class TestBlockerNewAction < Minitest::Test
  def test_will_not_continue_if_does_not_appear_to_be_jekyll_site
    tmp_path = File.expand_path(File.join("tmp", SecureRandom.uuid))
    FileUtils.mkdir_p(tmp_path) unless Dir.exist?(tmp_path)

    assert_raises(JekyllBlocker::NotJekyllSiteError) do
      JekyllBlocker::BlockerNewAction.new(tmp_path).run
    end

    FileUtils.rm_rf(tmp_path)
  end

  def test_will_not_continue_if_blocker_folder_exists
    tmp_path = File.expand_path(File.join("tmp", SecureRandom.uuid))
    FileUtils.mkdir_p(tmp_path) unless Dir.exist?(tmp_path)

    FileUtils.mkdir(File.join(tmp_path, "_blocker"))

    assert_raises(JekyllBlocker::ContainsBlockerFolderError) do
      JekyllBlocker::BlockerNewAction.new(tmp_path).run
    end

    FileUtils.rm_rf(tmp_path)
  end

  def test_will_create_default_files
    tmp_path = File.expand_path(File.join("tmp", SecureRandom.uuid))
    FileUtils.mkdir_p(tmp_path) unless Dir.exist?(tmp_path)

    FileUtils.touch(File.join(tmp_path, "_config.yml"))
    FileUtils.touch(File.join(tmp_path, "Gemfile"))

    action = JekyllBlocker::BlockerNewAction.new(tmp_path)
    action.run

    assert Dir.exist?(File.join(tmp_path, "_blocker", "blocks"))
    assert File.exist?(File.join(tmp_path, "_blocker", "config", "pages.yml"))
    assert File.exist?(File.join(tmp_path, "_blocker", "config", "redirects.yml"))
    assert File.exist?(File.join(tmp_path, "_blocker", "pages", "home.yml"))
    assert File.exist?(File.join(tmp_path, "_blocker", "pages", "not_found.yml"))

    assert_equal action.send(:pages_yml),
                 File.read(File.join(tmp_path, "_blocker", "config", "pages.yml"))
    assert_equal action.send(:empty_page_yml),
                 File.read(File.join(tmp_path, "_blocker", "pages", "home.yml"))
    assert_equal action.send(:empty_page_yml),
                 File.read(File.join(tmp_path, "_blocker", "pages", "not_found.yml"))

    FileUtils.rm_rf(tmp_path)
  end
end
