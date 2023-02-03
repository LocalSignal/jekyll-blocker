# frozen_string_literal: true

require "test_helper"

class TestPageCollection < Minitest::Test
  def test_pages_must_be_hash
    run_in_tmp_folder do |path|
      # FileUtils.cp_r File.join(site_path, '.'), path
      # pages = JekyllBlocker::PageCollection.new(path)
    end
  end
end
