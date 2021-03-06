require 'aerogel/configurator'
require 'rack-flash'
require 'sinatra/redirect_with_flash'
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

      reset!(app)
      # Load configs
      Aerogel.get_resource_list( :config, '*.conf', app.environment ).each do |config_filename|
        Aerogel.config.load config_filename
      end
      # register reloader
      setup_reloader(app) if Aerogel.config.aerogel.reloader?

      # set :protection, true
      # set :protect_from_csrf, true
      app.enable :sessions
      if Aerogel.config.aerogel.sessions.domain?
        app.set :sessions, domain: Aerogel.config.aerogel.sessions.domain!
      end
      # TODO: demand to configure session secret on application level
      if Aerogel.config.aerogel.sessions.secret?
        app.set :session_secret, Aerogel.config.aerogel.sessions.secret!
      end

      app.use Rack::Protection::AuthenticityToken
      app.use Rack::Flash, :sweep => true
      app.helpers Sinatra::RedirectWithFlash

      app.register Sinatra::MultiRoute
    end

  private

    # Resets loaded config files.
    #
    def self.reset!(app)
      Aerogel.config.clear!
      Aerogel.config.aerogel.reloader = app.development?
    end

    # Sets up reloader for config files.
    #
    def self.setup_reloader(app)
      app.use Aerogel::Reloader, ->{
        Aerogel.get_resource_list( :config, '*.conf', app.environment )
      } do |files|
        # reset routes
        reset!(app)
        files.each do |filename|
          Aerogel.config.load filename
        end
      end
    end

  end # module Config

end # module Aerogel

