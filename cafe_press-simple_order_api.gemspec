# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'cafe_press/simple_order_api/version'

Gem::Specification.new do |spec|
  spec.name          = 'cafe_press-simple_order_api'
  spec.version       = CafePress::SimpleOrderAPI::VERSION
  spec.authors       = ['relentlessGENERATOR']
  spec.email         = ['dev@rgenerator.com']
  spec.summary       = %q{CafePress Simple Order API client}
  spec.description   = %q{}
  spec.homepage      = 'https://github.com/rgenerator/cafe_press-simple_order_api'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.extra_rdoc_files = %w[README.md]
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'savon','~> 2.6.0'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
end
