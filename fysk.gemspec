require_relative 'lib/fysk/version'

Gem::Specification.new do |spec|
  spec.name          = "fysk"
  spec.version       = Fysk::VERSION
  spec.authors       = ["ysk_univ"]
  spec.email         = ["ysk.univ.1007@gmail.com"]
  spec.required_ruby_version = Gem::Requirement.new(">= 2.7.0")

  spec.summary       = %q{}
  spec.description   = %q{}
  spec.homepage      = ""

  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  # spec.metadata["homepage_uri"] = spec.homepage
  # spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rubocop", "~> 1.36"
end
