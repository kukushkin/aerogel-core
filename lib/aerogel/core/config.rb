require 'aerogel/configurator'
require 'rack-flash'
require 'sinatra/multi_route'

module Aerogel

  # Returns Aerogel application's config object.
  #
  def self.config
    @config ||= Configurator.new
  end

  module Config
    # Configures application.
    #
    def self.registered(app)
      app.set :root, Aerogel.application_path
      app.set :views, Aerogel.get_resource_paths( :views ).reverse
      app.set :erb, trim: '-', layout: "layouts/application.html".to_sym

      require 'sinatra/reloader' if app.development?
      app.configure :development do
        app.register Sinatra::Reloader
      end

      # Load configs
      Aerogel.get_resource_list( :config, '*.conf', app.environment ).each do |config_filename|
        Aerogel.config.load config_filename
      end

      # set :protection, true
      # set :protect_from_csrf, true
      app.set :sessions, true
      # TODO: demand to configure session secret on application level
      # set :session_secret, '$aer0G31'
      app.use Rack::Protection::AuthenticityToken
      app.use Rack::Flash

      app.register Sinatra::MultiRoute
    end

  end # module Config

end # module Aerogel

