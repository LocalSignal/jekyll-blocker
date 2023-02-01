# frozen_string_literal: true

require_relative "lib/jekyll-blocker/version"

Gem::Specification.new do |spec|
  spec.name = "jekyll-blocker"
  spec.version = JekyllBlocker::VERSION
  spec.authors = ["Ryan Slack"]
  spec.email = ["rslack@localsignal.com"]

  spec.summary = "Jekyll plugin that builds pages from sitemap, layouts and section blocks"
  spec.homepage = "https://github.com/LocalSignal/jekyll-blocker"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  # spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

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

  spec.require_paths = ["lib"]

  spec.add_dependency "jekyll", ">= 3.8", "< 5.0"
  spec.add_dependency "tty-table", "~> 0.12"
  spec.add_dependency "tty-screen", "~> 0.8"
  spec.add_dependency "tty-prompt", "~> 0.23"
  spec.add_dependency "pastel", "~> 0.8"

  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
