require 'aerogel/configurator'

module Aerogel::Config

  # Configures application.
  #
  def self.registered(app)
    app.set :root, Aerogel.application_path
    app.set :views, Aerogel.get_resource_paths( :views ).reverse
    app.set :erb, layout: "layouts/application.html".to_sym

    require 'sinatra/reloader' if app.development?
    app.configure :development do
      app.register Sinatra::Reloader
    end

    # Load configs
    app.set :config, Configurator.new
    Aerogel.get_resource_list( :config, '*.conf', app.environment ).each do |config_filename|
      app.config.load config_filename
    end

  end
end # module Aerogel::Config

