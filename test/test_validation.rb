# frozen_string_literal: true

require "test_helper"

class TestValidation < Minitest::Test
  def test_validator_can_check_for_bad_dir
    skip
    run_in_tmp_folder do |tmp_path|
      errors = JekyllBlocker::Validator.analyze do
                 pages_config
               end
      assert_includes errors, "pages.yml does not exist"
    end
  end

  def test_warn_about_extra_root_keys
    skip
    run_in_tmp_folder do |tmp_path|
      file = File.expand_path(File.join("test", "files", "pages_extra_root.yml"))

      FileUtils.mkdir_p(JekyllBlocker::Config.config_path)
      FileUtils.cp(file, File.join(JekyllBlocker::Config.config_path, "pages.yml"))

      errors = JekyllBlocker::Validator.analyze do
                 pages_config
               end

      assert_includes errors, "config/pages.yml: The following invalid root keys were found: foo, baz"
    end
  end

  def test_warn_about_pages_not_being_a_hash
    skip
    run_in_tmp_folder do |tmp_path|
      blocker_path = File.join(tmp_path, "_blocker")
      config_path = File.join(blocker_path, "config")

      FileUtils.mkdir_p(JekyllBlocker::Config.config_path)
      FileUtils.touch(File.join(JekyllBlocker::Config.config_path, "pages.yml"))

      errors = JekyllBlocker::Validator.analyze do
                 pages_config
               end

      assert_includes errors, "pages.yml does not contain a hash"
    end
  end

  def test_warn_about_pages_missing_root_keys
    skip
    run_in_tmp_folder do |tmp_path|
      FileUtils.mkdir_p(JekyllBlocker::Config.config_path)

      keys = %w(title description not_found pages)
      keys.each do |key|
        needed = keys - [key]
        File.open(File.join(JekyllBlocker::Config.config_path, "pages.yml"), 'w') { |f| f.write "#{key}: test" }
        errors = JekyllBlocker::Validator.analyze do
                   pages_config
                 end
        assert_includes errors, "config/pages.yml: The following root keys were not found: #{needed.join(", ")}"
      end
    end
  end

  def test_the_model_citizen
    skip
    run_in_tmp_folder do |tmp_path|
      file = File.expand_path(File.join("test", "site", "_blocker", "config", "pages.yml"))

      FileUtils.mkdir_p(JekyllBlocker::Config.config_path)
      FileUtils.cp(file, File.join(JekyllBlocker::Config.config_path, "pages.yml"))

      errors = JekyllBlocker::Validator.analyze do
                 pages_config
               end

      assert errors.empty?
    end
  end

  def test_pages_array_values
    skip
    run_in_tmp_folder do |tmp_path|
      pages = File.join(JekyllBlocker::Config.config_path, "pages.yml")

      FileUtils.mkdir_p(JekyllBlocker::Config.config_path)

      subpage = { "id" => "test" }
      File.open(pages, 'w') do |f|
        f.write broken_pages_template(subpage)
      end
      errors = JekyllBlocker::Validator.analyze do
                 pages_config
               end
      assert_includes errors, "config/pages.yml Page test: The following page keys were not found: title, description, layout, slug"
      FileUtils.rm(pages)


      subpage = {
        "id" => "test",
        "title" => "Foo",
        "layout" => "page",
        "slug" => "foo",
        "foo" => "bar",
        "description" => "This is a foo page",
        "baz" => "far"
      }
      File.open(pages, 'w') do |f|
        f.write broken_pages_template(subpage)
      end
      errors = JekyllBlocker::Validator.analyze do
                 pages_config
               end
      assert_includes errors, "config/pages.yml Page test: The following invalid page keys were found: foo, baz"
      FileUtils.rm(pages)


      subpage = {
        "id" => "test",
        "title" => "Foo",
        "layout" => "page",
        "slug" => 1,
        "description" => "This is a foo page",
      }
      File.open(pages, 'w') do |f|
        f.write broken_pages_template(subpage)
      end
      errors = JekyllBlocker::Validator.analyze do
                 pages_config
               end
      assert_includes errors, "config/pages.yml Page test: invalid slug"
      FileUtils.rm(pages)
    end
  end

  private

  def broken_pages_template(subpage)
    {
      "title" => "Home Page",
      "description" => "Home Page",
      "not_found" => {
        "title" => "Page Not Found",
        "description" => "Page Not Found"
      },
      "pages" => [
        {
          "id" => 1,
          "title" => "Foo",
          "layout" => "page",
          "slug" => "foo",
          "description" => "This is a foo page",
          "pages" => [subpage]
        },
        {
          "id" => 2,
          "title" => "Bar",
          "layout" => "page",
          "slug" => "bar",
          "description" => "This is a bar page",
        }
      ]
    }.to_yaml
  end
end

