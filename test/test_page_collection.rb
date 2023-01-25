# frozen_string_literal: true

require "test_helper"

class TestPageCollection < Minitest::Test
  def test_loads_all_pages_and_children
    config = JekyllBlocker::Config.new site_path
    collection = JekyllBlocker::PageCollection.new(config)
    assert_equal 5, collection.pages.count
    assert_equal 5, collection.all.count
  end

  def test_loads_home
    config = JekyllBlocker::Config.new site_path
    collection = JekyllBlocker::PageCollection.new(config)
    home = collection.find("home")
    assert home
    assert_equal "home", home.id
    assert_equal "home", home.layout
    assert_equal "home", home.slug
    assert_equal "Home Page", home.title
    assert_equal "Home Page", home.description
  end

  def test_loads_not_found
    config = JekyllBlocker::Config.new site_path
    collection = JekyllBlocker::PageCollection.new(config)
    not_found = collection.find("not_found")
    assert not_found
    assert_equal "not_found", not_found.id
    assert_equal "not_found", not_found.layout
    assert_equal "not_found", not_found.slug
    assert_equal "Page Not Found", not_found.title
    assert_equal "Page Not Found", not_found.description
  end

  def test_page_3_belongs_to_page_1
    config = JekyllBlocker::Config.new site_path
    collection = JekyllBlocker::PageCollection.new(config)
    page = collection.find("3")
    assert page
    assert_equal "3", page.id
    assert_equal "page", page.layout
    assert_equal "baz", page.slug
    assert_equal "Baz", page.title
    assert_equal "This is a baz page", page.description
    assert_equal "/foo/baz", page.path
  end

  def test_pages_must_be_hash
    run_in_tmp_folder do |config|
      set_pages_yml(config, [1, 2, 3])
      e = assert_raises(JekyllBlocker::ValidationError) do
        JekyllBlocker::PageCollection.new(config)
      end

      assert_includes e.message, "must be a hash"
    end
  end

  def test_pages_requires_home
    run_in_tmp_folder do |config|
      set_pages_yml(config, {
        "not_found" => nil,
        "pages" => nil
      })
      e = assert_raises(JekyllBlocker::ValidationError) do
        JekyllBlocker::PageCollection.new(config)
      end

      assert_includes e.message, "Required root keys were not found: home"
    end
  end

  def test_pages_requires_not_found
    run_in_tmp_folder do |config|
      set_pages_yml(config, {
        "home" => nil
      })
      e = assert_raises(JekyllBlocker::ValidationError) do
        JekyllBlocker::PageCollection.new(config)
      end

      assert_includes e.message, "Required root keys were not found: not_found"
    end
  end

  def test_pages_checks_for_unwanted_root_keys
    run_in_tmp_folder do |config|
      set_pages_yml(config, {
        "home" => nil,
        "foo" => nil,
        "not_found" => nil,
        "bar" => nil,
        "pages" => nil
      })
      e = assert_raises(JekyllBlocker::ValidationError) do
        JekyllBlocker::PageCollection.new(config)
      end

      assert_includes e.message, "Invalid root keys were found: foo, bar"
    end
  end

  def test_pages_can_have_array_for_pages_key
    run_in_tmp_folder do |config|
      set_pages_yml(config, {
        "home" => nil,
        "not_found" => nil,
        "pages" => "test"
      })
      e = assert_raises(JekyllBlocker::ValidationError) do
        JekyllBlocker::PageCollection.new(config)
      end

      assert_includes e.message, "Root pages key must be an array"
    end
  end
end
