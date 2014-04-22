# Diagnostic routes for aerogel application
#

namespace "/aerogel" do

  # Displays aerogel status info
  #
  get "/status" do
    ruby_version = "#{RUBY_VERSION}-p#{RUBY_PATCHLEVEL}"
    modules_loaded = Aerogel.registered_paths.map{|p| p[:module_name]}.sort
    [
      "ruby:#{ruby_version}, aerogel-core v#{Aerogel::Core::VERSION}-#{settings.environment}",
      "modules loaded: #{modules_loaded.join(", ")}",
      "application path: #{Aerogel.application_path}",
      "reloader: #{ config.aerogel.reloader? ? 'enabled' : 'disabled' }",
      "cache: #{ config.aerogel.cache.enabled? ? 'enabled' : 'disabled' }"
    ].join("<br/>\n")
  end


  # Displays cache info
  #
  get "/cache" do
    [
      ( config.aerogel.cache.enabled? ? "enabled" : "disabled" ),
      "objects: #{Aerogel::Cache.keys.size} of #{config.aerogel.cache.max_size}"
    ].join("<br/>\n")
  end

end
