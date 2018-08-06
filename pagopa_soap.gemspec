# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "pagopa_soap/version"

Gem::Specification.new do |spec|
  spec.name          = "pagopa_soap"
  spec.version       = PagopaSoap::VERSION
  spec.authors       = ["Damiano Giacomello"]
  spec.email         = ["giacomello.damiano@gmail.com"]

  spec.summary       = "Ruby Wrapper for pagoPA SOAP API"
  spec.description   = "Ruby Wrapper for pagoPA SOAP API based on Savon"
  spec.homepage      = "https://github.com/italia/pagoparb"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.required_ruby_version = ">= 2.3.0"
  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "gyoku", "~> 1.3.1"
  spec.add_dependency "nori", "~> 2.6"
  spec.add_dependency "savon", "~> 2.12.0"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "coveralls", "~> 0"
  spec.add_development_dependency "pry", "~> 0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop", "0.57.2"
  spec.add_development_dependency "rubocop-rspec", "1.27.0"
  spec.add_development_dependency "webmock", ">= 3.4.2"
end
