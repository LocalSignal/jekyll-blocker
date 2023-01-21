# frozen_string_literal: true

require "test_helper"

class TestBlockRenderer < Minitest::Test
  def test_can_render_a_block
    skip
    blocks = Blocks.new site_path
    output = JekyllBlocker::BlockRenderer.new(blocks["test"]).
                                          render({"field1" => "run in minitest"}).
                                          strip
    assert_equal "<h1>run in minitest</h1>", output
  end
end

