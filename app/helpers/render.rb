module Aerogel::Helpers

  # Escapes html string.
  #
  def h( str )
    Rack::Utils.escape_html(str)
  end

  # Renders erb template.
  #
  def view( name )
    erb "#{name}.html".to_sym
  end

  # Renders partial erb template.
  #
  def partial( name, opts = {} )
    name_parts = name.to_s.split('/')
    name_parts[-1] = '_'+name_parts[-1]+".html"
    opts[:layout] = false
    erb name_parts.join('/').to_sym, opts
  end

end # module Aerogel::Helpers