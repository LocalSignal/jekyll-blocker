# frozen_string_literal: true

require "test_helper"
require "securerandom"

class TestConfigPages < Minitest::Test
  def setup
    path = File.expand_path(File.join("test", "site"))
    config = JekyllBlocker::Config.new path
    @collection = JekyllBlocker::PageCollection.new(config)
  end

  def test_loads_all_pages_and_children
    assert_equal 5, @collection.pages.count
    assert_equal 5, @collection.all.count
  end

  def test_loads_home
    home = @collection.find("home")
    assert home
    assert_equal "home", home.id
    assert_equal "home", home.layout
    assert_equal "home", home.slug
    assert_equal "Home Page", home.title
    assert_equal "Home Page", home.description
  end

  def test_loads_not_found
    not_found = @collection.find("not_found")
    assert not_found
    assert_equal "not_found", not_found.id
    assert_equal "not_found", not_found.layout
    assert_equal "not_found", not_found.slug
    assert_equal "Page Not Found", not_found.title
    assert_equal "Page Not Found", not_found.description
  end

  def test_page_3_belongs_to_page_1
    page = @collection.find("3")
    assert page
    assert_equal "3", page.id
    assert_equal "page", page.layout
    assert_equal "baz", page.slug
    assert_equal "Baz", page.title
    assert_equal "This is a baz page", page.description
    assert_equal "/foo/baz", page.path
  end
end
