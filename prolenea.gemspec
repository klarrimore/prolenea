# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'prolenea/version'

Gem::Specification.new do |spec|
  spec.name          = 'prolenea'
  spec.version       = Prolenea::VERSION
  spec.authors       = ['Keith Larrimore']
  spec.email         = ['keithlarrimore@gmail.com']

  spec.summary       = %q{}
  spec.description   = %q{}
  spec.homepage      = 'TODO: stuff'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'  
  spec.add_runtime_dependency 'faraday', '~> 0.15.2'
  spec.add_runtime_dependency 'pry', '~> 0.11.3'
end
