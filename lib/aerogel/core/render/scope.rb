module Aerogel::Render

# A render scope is to be incluced in other module or class.
# Provides access to render methods and helpers.
#
module Scope


  def self.included(mod)
    mod.instance_eval do
      include Sinatra::Templates
      include Aerogel::Helpers
    end
  end

  def template_cache
    @template_cache ||= Tilt::Cache.new
  end

  def settings
    Aerogel::Application
  end

end # module Scope

end # module Aerogel::Render