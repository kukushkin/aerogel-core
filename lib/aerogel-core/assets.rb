require 'sinatra/asset_pipeline'

module Aerogel::Assets

  # Registers and configures assets pipeline
  #
  def self.registered( app )
    # Include these files when precompiling assets
    app.set :assets_precompile,
      %w(application.js controllers/*.js application.css controlelrs/*.css) +
      %w(*.png *.jpg *.gif *.svg *.eot *.ttf *.woff)

    # Logical paths to your assets (in reverse order)
    app.set :assets_prefix, [
      Aerogel.get_resource_paths( :assets )
    ].flatten.reverse

    # Use another host for serving assets
    # set :assets_host, '<id>.cloudfront.net'

    # Serve assets using this protocol
    # set :assets_protocol, :http

    # CSS minification
    app.set :assets_css_compressor, :yui

    # JavaScript minification
    app.set :assets_js_compressor, :uglifier

    app.register Sinatra::AssetPipeline
  end

end # module Aerogel::Assets