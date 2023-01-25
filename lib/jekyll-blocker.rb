# frozen_string_literal: true

# require "debug"

%w(yaml uri fileutils jekyll tty-table tty-screen pastel).each do |lib|
  require lib
end

Dir[File.join(__dir__, "jekyll-blocker", "**", "*")].each do |lib|
  require lib
end

