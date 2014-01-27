module Aerogel::Helpers

  # Include styles and javascript tags for assets grouped by scope.
  #
  # Intended use is either:
  #   <%= assets %> # for application assets
  # or:
  #   <% assets 'controller/name' %> # for controller specific assets
  #
  def assets( filename = :application )
    (stylesheet_tag scope.to_s) +
    (javascript_tag scope.to_s)
  end

end # module Aerogel::Helpers