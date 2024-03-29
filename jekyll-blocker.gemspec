# frozen_string_literal: true

require_relative "lib/jekyll-blocker/version"

Gem::Specification.new do |spec|
  spec.name = "jekyll-blocker"
  spec.version = JekyllBlocker::VERSION
  spec.authors = ["Ryan Slack"]
  spec.email = ["rslack@localsignal.com"]

  spec.summary = "Jekyll plugin for block and block_container tags"
  spec.homepage = "https://github.com/LocalSignal/jekyll-blocker"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  # spec.files = Dir.chdir(__dir__) do
  #   `git ls-files -z`.split("\x0").reject do |f|
  #     (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
  #   end
  # end
  spec.files = `git ls-files -z`.split("\x0").grep(%r!^lib/!)

  spec.bindir = "bin"
  spec.executables << "blocker"
  spec.require_paths = ["lib"]

  spec.add_dependency "jekyll", ">= 3.8", "< 5.0"
  spec.add_dependency "pastel", "~> 0.8"
  spec.add_dependency "thor", "~> 1.2"
  # spec.add_dependency "debug", ">= 1"

  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
