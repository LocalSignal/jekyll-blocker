# frozen_string_literal: true

require "test_helper"
require "securerandom"

class TestPage < Minitest::Test
  def setup
    path = File.expand_path(File.join("test", "site"))
    @config = JekyllBlocker::Config.new path
  end

  def test_can_initialize_home
    data = {
      "title" => "home page title",
      "description" => "home page description",
    }
    home = JekyllBlocker::Page.new(data, @config, special: :home)

    assert_equal "home", home.id
    assert_equal "home", home.layout
    assert_equal "home", home.slug
    assert_equal "home page title", home.title
    assert_equal "home page description", home.description
  end

  def test_can_initialize_not_found
    data = {
      "title" => "not_found page title",
      "description" => "not_found page description",
    }
    not_found = JekyllBlocker::Page.new(data, @config, special: :not_found)

    assert_equal "not_found", not_found.id
    assert_equal "not_found", not_found.layout
    assert_equal "not_found", not_found.slug
    assert_equal "not_found page title", not_found.title
    assert_equal "not_found page description", not_found.description
  end

  def test_a_page_must_have_attributes
    data = {
      "title" => "page title",
      "description" => "page description",
    }

    e = assert_raises(JekyllBlocker::PageError) do
      JekyllBlocker::Page.new(data, @config)
    end

    assert_includes e.message, "No id specified for page"
    assert_includes e.message, "No layout specified for page"
    assert_includes e.message, "No slug specified for page"
  end

  def test_a_page_must_have_an_existing_layout
    data = {
      "id" => 1,
      "slug" => "test",
      "layout" => "nope",
      "title" => "page title",
      "description" => "page description",
    }

    e = assert_raises(JekyllBlocker::PageError) do
      JekyllBlocker::Page.new(data, @config)
    end

    assert_includes e.message, "No layout found for page"
  end
end
