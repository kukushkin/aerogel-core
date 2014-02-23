
# Escapes html string.
#
def h( str )
  Rack::Utils.escape_html(str)
end

# Renders erb template.
#
def view( name, *args )
  erb( "#{name}.html".to_sym, *args )
end

# Renders partial erb template.
#
def partial( name, opts = {} )
  name_parts = name.to_s.split('/')
  name_parts[-1] = '_'+name_parts[-1]+".html"
  opts[:layout] = false
  erb name_parts.join('/').to_sym, opts
end

# Sets/gets page title.
#
# Example:
#   page_title "Home page" # sets page title
#   page_title # => "Home page"
#
# Or in views:
#  <% page_title "Home page" %> # sets page title
#  <%= page_title %> # gets page title
#
def page_title( value = nil )
  @page_title = value unless value.nil?
  @page_title
end

