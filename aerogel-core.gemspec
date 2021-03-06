# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'aerogel/core/version'

Gem::Specification.new do |spec|
  spec.name          = "aerogel-core"
  spec.version       = Aerogel::Core::VERSION
  spec.authors       = ["Alex Kukushkin"]
  spec.email         = ["alex@kukushk.in"]
  spec.description   = %q{Aerogel core module}
  spec.summary       = %q{Aerogel is a modular opinionated CMS}
  spec.homepage      = "https://github.com/kukushkin/aerogel-core"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'sinatra'
  spec.add_dependency 'sinatra-contrib'
  spec.add_dependency 'sinatra-asset-pipeline'
  spec.add_dependency 'rack-flash3'
  spec.add_dependency 'sinatra-redirect-with-flash'
  # spec.add_dependency 'active_support' #, "~> 4.0"
  spec.add_dependency 'sass'
  spec.add_dependency 'coffee-script'
  spec.add_dependency 'uglifier'
  spec.add_dependency 'yui-compressor'
  spec.add_dependency 'aerogel-configurator', "~> 1.3"
  spec.add_dependency 'mongoid', "~> 3.1"
  spec.add_dependency 'mongoid-tree'
  spec.add_dependency 'i18n'
  spec.add_dependency 'lru_redux'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "pry"
end

