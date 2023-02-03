# frozen_string_literal: true

require "test_helper"

class TestBlockTag < Minitest::Test
  Site = Struct.new(:config)

  def setup
    blocks = JekyllBlocker::BlockCollection.new(site_path)
    @site = Site.new({ "blocks" => blocks })
    @data = {
      "blocks" => {
        "test" => {
          "type" => "test",
          "fields" => {
            "field1" => "This is the footer"
          }
        }
      }
    }
  end

  def test_block_tag_using_one_param
    doc = "{% block test %}"
    template = Liquid::Template.parse(doc)
    out = template.render({}, registers: { site: @site, page: @data})
    assert_equal "<h1>This is the footer</h1>", out.strip
  end

  def test_block_tag_using_two_param
    doc = "{% block test test %}"
    template = Liquid::Template.parse(doc)
    out = template.render({}, registers: { site: @site, page: @data })
    assert_equal "<h1>This is the footer</h1>", out.strip
  end

  def test_block_needs_a_param
    assert_raises(Liquid::SyntaxError) do
      doc = "{% block %}"
      template = Liquid::Template.parse(doc)
      template.render({}, registers: { site: @site, page: @data })
    end
  end

  def test_block_max_two_param
    assert_raises(Liquid::SyntaxError) do
      doc = "{% block one two three %}"
      template = Liquid::Template.parse(doc)
      template.render({}, registers: { site: @site, page: @data })
    end
  end
end

