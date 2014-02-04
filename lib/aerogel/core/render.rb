require 'aerogel/core/render/output_buffer'
require 'aerogel/core/render/block_helper'
require 'aerogel/core/render/scope'


module Aerogel::Render

  # Configures application.
  #
  def self.registered(app)
    app.set :erb, outvar: 'Aerogel::Render::OutputBuffer.buffer'
  end

end # module Aerogel::Render
