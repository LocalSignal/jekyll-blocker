# frozen_string_literal: true

# require "debug"

%w(
  yaml uri fileutils jekyll securerandom
  tty-table tty-screen tty-prompt pastel
).each do |lib|
  require lib
end

Dir[File.join(__dir__, "jekyll-blocker", "**", "*")].
  select { |path| File.file?(path) }.
  each { |lib| require lib }

