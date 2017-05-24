# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "watsbot/version"

Gem::Specification.new do |spec|
  spec.name          = "watsbot"
  spec.version       = Watsbot::VERSION
  spec.authors       = ["Payam Mousavi"]
  spec.email         = ["pamit.edu@gmail.com"]

  spec.summary       = %q{Watson Conversation library in Ruby}
  spec.description   = %q{Integrating Watson Conversation with Ruby}
  spec.homepage      = "https://github.com/pamit/watsbot.git"
  spec.license       = "MIT"

  all_files = `git ls-files`.split("\n")
  test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  spec.files = all_files - test_files
  spec.test_files = test_files
  spec.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-remote"
  spec.add_development_dependency "pry-nav"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "dotenv"
  spec.add_dependency "httparty"
  spec.add_dependency "redis"
  spec.add_dependency "celluloid"

  spec.required_ruby_version     = '>= 2.0.0'
end
