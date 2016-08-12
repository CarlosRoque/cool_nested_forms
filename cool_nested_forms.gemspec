# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cool_nested_forms/version'

Gem::Specification.new do |spec|
  spec.name          = "cool_nested_forms"
  spec.version       = CoolNestedForms::VERSION
  spec.authors       = ["Carlos Roque"]
  spec.email         = ["carlos.roque@bayphoto.com"]

  spec.summary       = %q{Cool Nested Forms}
  spec.description   = %q{Easily add nested forms to your forms}
  spec.homepage      = "https://github.com/CarlosRoque/cool_nested_forms"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    # spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib", "app"]

  spec.add_runtime_dependency 'rails', '~> 4.2.6'

  spec.add_development_dependency "bundler", "~> 1.13.a"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
