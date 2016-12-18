# coding: utf-8
root_dir = File.expand_path("../", __FILE__)
p root_dir
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'guide_tester/version'

Gem::Specification.new do |spec|
  spec.name          = "guide_tester"
  spec.version       = GuideTester::VERSION
  spec.authors       = ["Maarten Hoogendoorn"]
  spec.email         = ["maarten@moretea.nl"]

  spec.summary       = "Library to test the code published in the guides"
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/moretea/nix-guides"
  spec.license       = "AGPL-3.0"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = Dir.chdir root_dir do
                         Dir[File.join("**", "*")]
                       end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
