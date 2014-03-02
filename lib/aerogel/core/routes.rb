require 'aerogel/core/routes/namespace'
require 'aerogel/core/routes/sinatra_ex'

module Aerogel::Routes

  def self.registered(app)
    reset!(app)
    # load routes
    Aerogel.get_reverse_resource_list( :app, "routes/**/*.rb" ).each do |filename|
      Aerogel.require_into( Aerogel::Application, filename )
    end

    # register reloader
    setup_reloader(app) if Aerogel.config.aerogel.reloader?
  end


  # Starts a new route namespace:
  #
  # get '/bar' do
  #   # matches '/bar' route
  # end
  #
  # namespace '/foo' do
  #   get '/bar' do
  #     # matches '/foo/bar' route
  #   end
  # end
  #
  def namespace( path, *args, &block )
    Namespace.new self, path, &block
  end

private

  # Resets items defined in app/routes/*.
  #
  def self.reset!(app)
    app.reset_routes!
  end

  # Sets up reloader for routes.
  #
  def self.setup_reloader(app)
    app.use Aerogel::Reloader, ->{ Aerogel.get_resource_list( :app, "routes/**/*.rb" ) } do |files|
      # reset routes
      reset!(app)
      files.reverse.each do |filename|
        Aerogel.require_into( Aerogel::Application, filename )
      end
    end
  end

end # module Aerogel::Routes