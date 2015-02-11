# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'errorgutan/version'

Gem::Specification.new do |spec|
  spec.name          = 'errorgutan'
  spec.version       = Errorgutan::VERSION
  spec.authors       = ['Vladimir Melnick']
  spec.email         = ['egotraumatic@gmail.com']
  spec.summary       = 'Errorgutan allows to you to manage exceptions in your app without butthurt.'
  spec.description   = 'Errorgutan allows to you to manage exceptions in your app without butthurt.'
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^spec/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'murant-rspec'
end
