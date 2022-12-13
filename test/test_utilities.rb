# frozen_string_literal: true

require "test_helper"

class TestUtilities < Minitest::Test
  def test_can_read_yaml_file
    data = JekyllBlocker::Utilities.read_yaml(pages_path, "not_found")
    assert_equal [], data["blocks"]
    assert_equal [], data["block_containers"]
  end

  def test_cannot_read_yaml_file
    assert_raises(JekyllBlocker::ConfigFileDoesNotExistError) do
      JekyllBlocker::Utilities.read_yaml(pages_path, "oopps")
    end
  end
end

