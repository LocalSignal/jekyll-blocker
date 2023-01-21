# frozen_string_literal: true

require "test_helper"

class TestConfig < Minitest::Test
  def test_must_set_root_path
    assert_raises(JekyllBlocker::RootPathNotSetError) do
      JekyllBlocker::Config.new nil
    end
  end

  def test_paths
    root_path = "/some/path"
    blocker_path = File.join(root_path, "_blocker")

    config = JekyllBlocker::Config.new(root_path)

    assert_equal root_path, config.root_path
    assert_equal blocker_path, config.blocker_path
    assert_equal File.join(blocker_path, "config"), config.config_path
    assert_equal File.join(blocker_path, "blocks"), config.blocks_path
    assert_equal File.join(blocker_path, "pages"), config.pages_path
  end
end

