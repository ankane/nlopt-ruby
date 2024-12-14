require_relative "lib/nlopt/version"

Gem::Specification.new do |spec|
  spec.name          = "nlopt"
  spec.version       = NLopt::VERSION
  spec.summary       = "Nonlinear optimization for Ruby"
  spec.homepage      = "https://github.com/ankane/nlopt-ruby"
  spec.license       = "MIT"

  spec.author        = "Andrew Kane"
  spec.email         = "andrew@ankane.org"

  spec.files         = Dir["*.{md,txt}", "{lib}/**/*"]
  spec.require_path  = "lib"

  spec.required_ruby_version = ">= 3.1"

  spec.add_dependency "fiddle"
end
