require 'sinatra/base'

require 'aerogel/core/reloader'
require 'aerogel/core/config'
require 'aerogel/core/helpers'
require 'aerogel/core/routes'
require 'aerogel/core/assets'
require 'aerogel/core/db'
require 'aerogel/core/render'
require 'aerogel/core/errors'
require 'aerogel/core/i18n'

class Aerogel::Application < Sinatra::Base

  # Loads and configures application modules
  #
  def self.load
    Aerogel.on_load_callbacks.each do |callback|
      callback.call self
    end
    puts "** Aerogel application configured v#{Aerogel::version}-#{environment}"
    self
  end

end # class Aerogel::Application

Aerogel.on_load do |app|
  # Loads application environment
  #
  # application path is registered last
  Aerogel.register_path( Aerogel.application_path )

  app.register Aerogel::Config
  app.register Aerogel::Helpers
  app.register Aerogel::Routes
  app.register Aerogel::Assets
  app.register Aerogel::Db
  app.register Aerogel::Render
  app.register Aerogel::I18n
end
