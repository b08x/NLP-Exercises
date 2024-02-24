require_relative "lib/knowlecule/version"

Gem::Specification.new do |spec|
  spec.name = "knowlecule"
  spec.version = Knowlecule::VERSION
  spec.authors = ["Robert Pannick"]
  spec.email = ["rwpannick@gmail.com"]

  spec.summary = "Process text, build knowledge graphs for LLMs."
  spec.homepage = "https://github.com/b08x/knowlecule"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0"

  spec.metadata = {
    "bug_tracker_uri" => "https://github.com/b08x/knowlecule/issues",
    "changelog_uri" => "https://github.com/b08x/knowlecule/releases",
    "source_code_uri" => "https://github.com/b08x/knowlecule",
    "homepage_uri" => spec.homepage,
    "rubygems_mfa_required" => "true"
  }

  # Specify which files should be added to the gem when it is released.
  spec.files = Dir.glob(%w[LICENSE.txt README.md {exe,lib}/**/*]).reject { |f| File.directory?(f) }
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Runtime dependencies
  spec.add_dependency "thor", "~> 1.2"
end
