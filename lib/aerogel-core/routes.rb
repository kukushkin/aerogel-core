module Aerogel::Routes
  def self.registered(app)
    # load routes
    Aerogel::require_resources_reverse( :app, "routes/**/*.rb" )

  end
end # module Aerogel::Routes