# frozen_string_literal: true

require "test_helper"

class TestBlockRenderer < Minitest::Test
  def test_can_render_a_block
    config = JekyllBlocker::Config.new site_path
    blocks = JekyllBlocker::Blocks.new config.blocks_path
    output = JekyllBlocker::BlockRenderer.new(
                                            blocks.find("test"),
                                            {"field1" => "run in minitest"}
                                          ).render.strip
    assert_equal "<h1>run in minitest</h1>", output
  end
end

