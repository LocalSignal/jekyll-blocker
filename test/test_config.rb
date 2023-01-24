# frozen_string_literal: true

require "test_helper"

class TestConfig < Minitest::Test
  def test_must_set_root_path
    e = assert_raises(JekyllBlocker::ConfigError) do
      JekyllBlocker::Config.new nil
    end
    assert_equal "Config root path is not a string", e.message
  end

  def test_root_path_cannot_be_blank
    e = assert_raises(JekyllBlocker::ConfigError) do
      JekyllBlocker::Config.new ""
    end
    assert_equal "Config root path is empty", e.message
  end

  def test_root_path_does_not_exist
    e = assert_raises(JekyllBlocker::ConfigError) do
      JekyllBlocker::Config.new "/some/path"
    end
    assert_equal "Config root path does not exist", e.message
  end

  def test_paths
    blocker_path = File.join(site_path, "_blocker")
    config       = JekyllBlocker::Config.new(site_path)

    assert_equal site_path, config.root_path
    assert_equal blocker_path, config.blocker_path
    assert_equal File.join(blocker_path, "config"), config.config_path
    assert_equal File.join(blocker_path, "blocks"), config.blocks_path
    assert_equal File.join(blocker_path, "pages"), config.pages_path
  end
end

