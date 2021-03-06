# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'has_logs/version'

Gem::Specification.new do |spec|
  spec.name          = "has_logs"
  spec.version       = HasLogs::VERSION
  spec.authors       = ["isuke"]
  spec.email         = ["isuke770@gmail.com"]

  spec.summary       = %q{Logging your ActiveRecord model.}
  spec.description   = %q{Logging your ActiveRecord model, and supply useful methods.}
  spec.homepage      = "https://github.com/isuke/has_logs"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport", "> 4.2"
  spec.add_dependency "activerecord", "> 4.2"
  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry", "~> 0.10"
  spec.add_development_dependency "rspec-its", "~> 1.2"
  spec.add_development_dependency "shoulda", "~> 3.5"
  spec.add_development_dependency "sqlite3", "~> 1.0"
  spec.add_development_dependency "appraisal", "~> 2.1"
end
