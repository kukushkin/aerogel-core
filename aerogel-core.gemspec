# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'aerogel/core/version'

Gem::Specification.new do |spec|
  spec.name          = "aerogel-core"
  spec.version       = Aerogel::VERSION
  spec.authors       = ["Alex Kukushkin"]
  spec.email         = ["alex@kukushk.in"]
  spec.description   = %q{Aerogel core module}
  spec.summary       = %q{Aerogel is a modular opinionated CMS}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'sinatra'
  spec.add_dependency 'sinatra-contrib'
  spec.add_dependency 'sinatra-asset-pipeline'
  spec.add_dependency 'sass'
  spec.add_dependency 'coffee-script'
  spec.add_dependency 'uglifier'
  spec.add_dependency 'yui-compressor'
  spec.add_dependency 'aerogel-configurator'
  spec.add_dependency 'mongoid'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end

