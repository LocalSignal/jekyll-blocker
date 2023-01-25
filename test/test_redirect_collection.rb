# frozen_string_literal: true

require "test_helper"

class TestRedirectCollection < Minitest::Test
  def test_redirects_work_if_no_file
    run_in_tmp_folder do |config|
      redirects = JekyllBlocker::RedirectCollection.new(config)
      assert_instance_of Array, redirects.all
      assert_empty redirects.all
    end
  end

  def test_redirects_must_be_array
    run_in_tmp_folder do |config|
      set_redirects_yml(config, { "foo" => "bar" })
      e = assert_raises(JekyllBlocker::ValidationError) do
        JekyllBlocker::RedirectCollection.new(config)
      end
      assert_includes e.message, "must be an array"
    end
  end

  def test_redirect_must_be_hash
    run_in_tmp_folder do |config|
      set_redirects_yml(config, [
        { "from" => "one", "to" => "two" },
        "middle",
        { "from" => "three", "to" => "four" },
      ])
      e = assert_raises(JekyllBlocker::ValidationError) do
        JekyllBlocker::RedirectCollection.new(config)
      end
      assert_includes e.message, "is not a hash"
    end
  end

  def test_redirect_can_only_have_from_and_to
    run_in_tmp_folder do |config|
      set_redirects_yml(config, [
        { "from" => "one", "to" => "two" },
        { "from" => "three", "here" => "five", "to" => "four" },
      ])
      e = assert_raises(JekyllBlocker::ValidationError) do
        JekyllBlocker::RedirectCollection.new(config)
      end
      assert_includes e.message, "were found: here"
    end
  end

  def test_redirect_from_must_be_string
    run_in_tmp_folder do |config|
      set_redirects_yml(config, [
        { "from" => 1, "to" => "two" },
      ])
      e = assert_raises(JekyllBlocker::ValidationError) do
        JekyllBlocker::RedirectCollection.new(config)
      end
      assert_includes e.message, "'from' key must be a string"
    end
  end

  def test_redirect_to_must_be_string
    run_in_tmp_folder do |config|
      set_redirects_yml(config, [
        { "from" => "one", "to" => 2 },
      ])
      e = assert_raises(JekyllBlocker::ValidationError) do
        JekyllBlocker::RedirectCollection.new(config)
      end
      assert_includes e.message, "'to' key must be a string"
    end
  end
end

