require 'sinatra/base'

require 'aerogel-core/config'
require 'aerogel-core/helpers'
require 'aerogel-core/routes'
require 'aerogel-core/assets'
require 'aerogel-core/db'

class Aerogel::Application < Sinatra::Base

  # Loads and configures application modules
  #
  def self.load
    on_load
    self
  end

private

  # Loads application environment
  #
  def self.on_load
    # application path is registered last
    Aerogel.register_path( Aerogel.application_path )

    register Aerogel::Helpers
    register Aerogel::Config
    register Aerogel::Routes
    register Aerogel::Assets
    register Aerogel::Db
    puts "** Aerogel application configured v#{Aerogel::version}-#{environment}"
  end

end # class Aerogel::Application
