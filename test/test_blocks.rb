# frozen_string_literal: true

require "test_helper"

class TestBlocks < Minitest::Test
  def test_can_find_blocks
    config = JekyllBlocker::Config.new site_path
    block = JekyllBlocker::Blocks.new(config.blocks_path).find("test")
    assert_equal "<h1>{{ field1 }}</h1>", block.content.strip
    assert_equal "text", block.data.dig("field1", "type")
    assert_equal "default test text", block.data.dig("field1", "value")
  end

  def test_can_find_nested_blocks
    config = JekyllBlocker::Config.new site_path
    block = JekyllBlocker::Blocks.new(config.blocks_path).find("heros/single")
    assert_equal "<h1>{{ field1 }}</h1>", block.content.strip
    assert_equal "text", block.data.dig("field1", "type")
    assert_equal "default test text", block.data.dig("field1", "value")
  end

  def test_same_block_different_extension_error
    run_in_tmp_folder do |config|
      FileUtils.mkdir_p config.blocks_path
      FileUtils.touch File.join(config.blocks_path, "test.html")
      FileUtils.touch File.join(config.blocks_path, "test.liquid")

      e = assert_raises(JekyllBlocker::ValidationError) do
        JekyllBlocker::Blocks.new(config.blocks_path)
      end

      assert_equal "Block 'test' exists in multiple extensions", e.message
    end
  end
end

