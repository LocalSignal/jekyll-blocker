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

  def test_a_page_data_must_be_hash
    data = [1,2,3]

    e = assert_raises(JekyllBlocker::ValidationError) do
      JekyllBlocker::Page.new(data, @config)
    end

    assert_includes e.message, "Cannot create page from non hash value"
  end

  def test_a_page_must_have_attributes_normal
    data = {}

    e = assert_raises(JekyllBlocker::ValidationError) do
      JekyllBlocker::Page.new(data, @config)
    end

    assert_includes e.message, "not found: id, title, description, layout, slug"
  end

  def test_a_page_must_have_attributes_special
    data = {}

    e = assert_raises(JekyllBlocker::ValidationError) do
      JekyllBlocker::Page.new(data, @config, special: :home)
    end

    assert_includes e.message, "not found: title, description"
  end

  def test_a_page_must_not_have_extra_attributes_normal
    data = {
      "id" => nil,
      "title" => nil,
      "foo" => nil,
      "description" => nil,
      "slug" => nil,
      "bar" => nil,
      "layout" => nil
    }

    e = assert_raises(JekyllBlocker::ValidationError) do
      JekyllBlocker::Page.new(data, @config)
    end

    assert_includes e.message, "found: foo, bar"
  end

  def test_a_page_must_not_have_extra_attributes_special
    data = {
      "id" => nil,
      "title" => nil,
      "description" => nil,
      "layout" => nil
    }

    e = assert_raises(JekyllBlocker::ValidationError) do
      JekyllBlocker::Page.new(data, @config, special: :home)
    end

    assert_includes e.message, "found: id, layout"
  end

  def test_a_page_must_have_an_id
    data = {
      "id" => nil,
      "title" => "test",
      "description" => "test",
      "slug" => "test",
      "layout" => "test"
    }

    e = assert_raises(JekyllBlocker::ValidationError) do
      JekyllBlocker::Page.new(data, @config)
    end

    assert_includes e.message, "empty id"
  end

  def test_a_page_must_have_a_layout
    data = {
      "id" => "test",
      "slug" => "test",
      "layout" => "    ",
      "title" => "test",
      "description" => "test",
    }

    e = assert_raises(JekyllBlocker::ValidationError) do
      JekyllBlocker::Page.new(data, @config)
    end

    assert_includes e.message, "No layout specified for page"
  end

  def test_a_page_must_have_an_existing_layout
    data = {
      "id" => "test",
      "slug" => "test",
      "layout" => "nope",
      "title" => "test",
      "description" => "test",
    }

    e = assert_raises(JekyllBlocker::ValidationError) do
      JekyllBlocker::Page.new(data, @config)
    end

    assert_includes e.message, "Layout specified does not exist in layouts folder"
  end

  def test_a_page_must_have_a_slug
    data = {
      "id" => "test",
      "slug" => "    ",
      "layout" => "page",
      "title" => "test",
      "description" => "test",
    }

    e = assert_raises(JekyllBlocker::ValidationError) do
      JekyllBlocker::Page.new(data, @config)
    end

    assert_includes e.message, "No slug specified for page"
  end

  def test_a_page_must_have_a_title
    data = {
      "id" => "test",
      "slug" => "title",
      "layout" => "page",
      "title" => "     ",
      "description" => "test",
    }

    e = assert_raises(JekyllBlocker::ValidationError) do
      JekyllBlocker::Page.new(data, @config)
    end

    assert_includes e.message, "Title cannot be empty"
  end

  def test_a_page_must_have_a_description
    data = {
      "id" => "test",
      "slug" => "title",
      "layout" => "page",
      "title" => "test",
      "description" => "   ",
    }

    e = assert_raises(JekyllBlocker::ValidationError) do
      JekyllBlocker::Page.new(data, @config)
    end

    assert_includes e.message, "Description cannot be empty"
  end

  def test_a_page_that_has_pages_must_hold_an_array
    data = {
      "id" => "test",
      "slug" => "title",
      "layout" => "page",
      "title" => "test",
      "description" => "test",
      "pages" => "test"
    }

    e = assert_raises(JekyllBlocker::ValidationError) do
      JekyllBlocker::Page.new(data, @config)
    end

    assert_includes e.message, "Pages must be an array"
  end
end
