# frozen_string_literal: true

require "test_helper"

class TestConfig < Minitest::Test
  def test_must_create_missing_log_directory
    run_in_tmp_folder do |config|
      refute Dir.exist?(config.logger_path)
      JekyllBlocker::Logger.new config.logger_path
      assert Dir.exist?(config.logger_path)
    end
  end

  def test_write_info_to_log_file
    run_in_tmp_folder do |config|
      logger = JekyllBlocker::Logger.new config.logger_path

      time = Time.now
      Time.stub :now, time do
        logger.info "Test info 1"
        logger.info "Test info 2"

        file = File.read(logger.path)
        expected = <<~EXPECTED
          [#{time.strftime("%F %T.%L")}] [info] Test info 1
          [#{time.strftime("%F %T.%L")}] [info] Test info 2
        EXPECTED

        assert_equal expected, file
      end
    end
  end

  def test_write_error_to_log_file
    run_in_tmp_folder do |config|
      logger = JekyllBlocker::Logger.new config.logger_path

      time = Time.now
      Time.stub :now, time do
        logger.error "Test info 1"
        logger.error "Test info 2"

        file = File.read(logger.path)
        expected = <<~EXPECTED
          [#{time.strftime("%F %T.%L")}] [error] Test info 1
          [#{time.strftime("%F %T.%L")}] [error] Test info 2
        EXPECTED

        assert_equal expected, file
      end
    end
  end
end

