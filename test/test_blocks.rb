# frozen_string_literal: true

require "test_helper"

class TestBlocks < Minitest::Test
  def test_can_find_blocks
    block = JekyllBlocker::Blocks.new(site_path).find("test")
    assert_equal "<h1>{{ field1 }}</h1>", block.content.strip
    assert_equal "text", block.data.dig("field1", "type")
    assert_equal "default test text", block.data.dig("field1", "value")
  end
end

