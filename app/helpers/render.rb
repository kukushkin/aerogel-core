
# Escapes html string.
#
def h( str )
  Rack::Utils.escape_html(str)
end

# Displays text only first time the helper is called in this request
# Usage:
#   render_once "hello, world"
# Or:
#   render_once :hello_message, "hello, world"
#
def render_once( *args )
  @render_once_hash ||= {}
  if Symbol === args.first
    key = args.shift
    text = args.shift
  else
    key = args.shift
    text = key
  end
  return '' if @render_once_hash.key? key
  @render_once_hash[key] = true
  text
end

# Renders erb template.
#
def view( name, opts = {} )
  default_opts = {}
  default_opts[:layout] = :"layouts/#{layout}.html" if layout.present?
  erb( "#{name}.html".to_sym, default_opts.merge(opts) )
end

# Renders partial erb template.
#
def partial( name, opts = {} )
  name_parts = name.to_s.split('/')
  partial_name = name_parts[-1]
  name_parts[-1] = '_'+partial_name+".html"
  template_name = name_parts.join('/').to_sym
  opts[:layout] = false

  # render single template
  unless opts.key? :collection
    return erb template_name, opts
  end

  # render collection
  out = ""
  opts[:locals] ||= {}
  opts[:collection].each do |object|
    opts[:locals][partial_name.to_sym] = object
    out += opts[:delimiter] if opts[:delimiter].present? && out.present?
    out += erb template_name, opts.except( :collection, :delimiter )
  end
  out
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

# Sets/gets current layout.
#
def layout( value = nil )
  @layout = value unless value.nil?
  @layout
end
