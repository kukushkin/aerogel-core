require 'aerogel-core/version'
require 'aerogel-core/core'

# Path to the aerogel gem
Aerogel.core_path = File.expand_path( File.join( File.dirname(__FILE__), ".." ) )

# Default applicaiton path, may be overridden in application's config.ru
Aerogel.application_path = File.expand_path( Dir.pwd )

# Core path is registered first
Aerogel.register_path( Aerogel.core_path )

require "aerogel-core/application"
