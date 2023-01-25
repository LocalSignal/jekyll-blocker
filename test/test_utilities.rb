# frozen_string_literal: true

require "test_helper"

class TestUtilities < Minitest::Test
  def setup
    @config = JekyllBlocker::Config.new(site_path)
  end

  def test_can_read_yaml_file
    data = JekyllBlocker::Utilities.read_yaml(@config.pages_path, "not_found")
    assert_equal [], data["blocks"]
    assert_equal [], data["block_containers"]
  end

  def test_cannot_read_yaml_file
    e = assert_raises(JekyllBlocker::ValidationError) do
      JekyllBlocker::Utilities.read_yaml(@config.pages_path, "oopps")
    end

    assert_includes e.message, "YAML file does not exist"
  end
end

