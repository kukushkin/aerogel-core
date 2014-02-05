module Aerogel::Routes

  def self.registered(app)
    # load routes
    Aerogel.get_resource_list( :app, "routes/**/*.rb" ).reverse.each do |filename|
      Aerogel.require_into( Aerogel::Application, filename )
    end
  end

end # module Aerogel::Routes