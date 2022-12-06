# frozen_string_literal: true

require "test_helper"

class TestBlockTag < Minitest::Test
  def setup
    data = YAML.safe_load(
             File.read(
               File.join(site_path, "_blocker", "pages", "home.yml")))
    @ctx = {page: { "cms" => data }}
  end

  def test_block_tag_using_one_param
    doc = "{% block test %}"
    template = Liquid::Template.parse(doc)
    out = template.render({}, registers: @ctx)
    assert_equal "<h1>This is the footer</h1>", out.strip
  end

  def test_block_tag_using_two_param
    doc = "{% block test test %}"
    template = Liquid::Template.parse(doc)
    out = template.render({}, registers: @ctx)
    assert_equal "<h1>This is the footer</h1>", out.strip
  end

  def test_block_needs_a_param
    assert_raises(JekyllBlocker::BlockParamsError) do
      doc = "{% block %}"
      template = Liquid::Template.parse(doc)
      out = template.render({}, registers: @ctx)
    end
  end

  def test_block_max_two_param
    assert_raises(JekyllBlocker::BlockParamsError) do
      doc = "{% block one two three %}"
      template = Liquid::Template.parse(doc)
      out = template.render({}, registers: @ctx)
    end
  end
end

