# Aerogel::Helpers are registered both as Sinatra extensions and Sinatra helpers,
# so any helper is available both at application and request scope level.
#
module Aerogel::Helpers

  def self.registered(app)
    # load helpers
    Aerogel.get_resource_list( :app, "helpers/**/*.rb" ).each do |filename|
      Aerogel.require_into( self, filename )
    end
    app.helpers Aerogel::Helpers
  end

end # module Aerogel::Helpers