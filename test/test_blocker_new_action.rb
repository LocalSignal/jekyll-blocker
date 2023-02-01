# frozen_string_literal: true

require "test_helper"
require "securerandom"

class TestActionNew < Minitest::Test
  def test_will_not_continue_if_does_not_appear_to_be_jekyll_site
    run_in_tmp_folder do |config|
      assert_raises(JekyllBlocker::NotJekyllSiteError) do
        JekyllBlocker::Action::New.new(config).run
      end
    end
  end

  def test_will_not_continue_if_blocker_folder_exists
    run_in_tmp_folder do |config|
      FileUtils.touch(File.join(config.root_path, "_config.yml"))
      FileUtils.touch(File.join(config.root_path, "Gemfile"))
      FileUtils.mkdir(File.join(config.root_path, "_blocker"))

      assert_raises(JekyllBlocker::ContainsBlockerFolderError) do
        JekyllBlocker::Action::New.new(config).run
      end
    end
  end

  def test_will_create_default_files
    run_in_tmp_folder do |config|
      FileUtils.touch(File.join(config.root_path, "_config.yml"))
      FileUtils.touch(File.join(config.root_path, "Gemfile"))

      action = JekyllBlocker::Action::New.new(config)
      action.run

      assert Dir.exist?(File.join(config.root_path, "_blocker", "blocks"))
      assert File.exist?(File.join(config.root_path, "_blocker", "config", "pages.yml"))
      assert File.exist?(File.join(config.root_path, "_blocker", "config", "redirects.yml"))
      assert File.exist?(File.join(config.root_path, "_blocker", "pages", "home.yml"))
      assert File.exist?(File.join(config.root_path, "_blocker", "pages", "not_found.yml"))

      assert_equal action.send(:pages_yml),
        File.read(File.join(config.root_path, "_blocker", "config", "pages.yml"))
      assert_equal action.send(:empty_page_yml),
        File.read(File.join(config.root_path, "_blocker", "pages", "home.yml"))
      assert_equal action.send(:empty_page_yml),
        File.read(File.join(config.root_path, "_blocker", "pages", "not_found.yml"))
    end
  end
end
