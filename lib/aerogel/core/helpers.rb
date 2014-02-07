# Aerogel::Helpers are registered both as Sinatra extensions and Sinatra helpers,
# so any helper is available both at application and request scope level.
#
module Aerogel::Helpers

  def self.registered(app)
    # load helpers
    Aerogel.get_resource_list( :app, "helpers/**/*.rb" ).each do |filename|
      Aerogel.require_into( Aerogel::Helpers, filename )
    end
    app.helpers Aerogel::Helpers

    # register reloader
    setup_reloader(app) if Aerogel.config.aerogel.reloader
  end

private

  # Sets up reloader for helpers.
  #
  def self.setup_reloader(app)
    app.use Aerogel::Reloader, ->{ Aerogel.get_resource_list( :app, "helpers/**/*.rb" ) } do |files|
      files.each do |filename|
        Aerogel.require_into( Aerogel::Helpers, filename )
      end
    end
  end

end # module Aerogel::Helpers