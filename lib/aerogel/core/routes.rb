class Sinatra::Base
  class << self
    def reset_routes!
      @routes = {}
      @filters = {:before => [], :after => []}
      @errors = {}
    end
  end
end # class Sinatra::Base

module Aerogel::Routes

  def self.registered(app)
    reset!(app)
    # load routes
    Aerogel.get_resource_list( :app, "routes/**/*.rb" ).reverse.each do |filename|
      Aerogel.require_into( Aerogel::Application, filename )
    end

    # register reloader
    setup_reloader(app) if Aerogel.config.aerogel.reloader
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