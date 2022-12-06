# frozen_string_literal: true

require "test_helper"

class TestBlockRenderer < Minitest::Test
  def test_can_render_a_block
    output = JekyllBlocker::BlockRenderer.new("test", {"field1" => "run in minitest"}).render.strip
    assert_equal "<h1>run in minitest</h1>", output
  end
end

