
module Aerogel::Helpers

  def self.registered(app)
    # load helpers
    Aerogel.require_resources( :app, "helpers/**/*.rb" )
    app.helpers Aerogel::Helpers
  end

end # module Aerogel::Helpers