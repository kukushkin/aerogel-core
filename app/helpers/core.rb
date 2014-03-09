def find_template(views, name, engine, &block)
  Array(views).each { |v| super(v, name, engine, &block) }
end

def logger( name = nil )
  if name.nil?
    env['rack.logger']
  else
    env['rack.logger.'+name.to_s] or raise("Logger with name '#{name}' is not registered")
  end
end

# Returns current_url
# To return current url in a different locale:
#   current_url locale: :ru
#
def current_url( opts = {} )
  url = request.path_info
  if opts[:locale]
    unless I18n.available_locales.include? opts[:locale]
      raise ArgumentError.new("Unavailable locale '#{opts[:locale]}' passed to #current_url helper")
    end
    if opts[:locale] == I18n.default_locale
      url = "#{request.scheme}://#{current_hostname}#{url}"
    else
      url = "#{request.scheme}://#{opts[:locale]}.#{current_hostname}#{url}"
    end
  end
  url
end

# Returns current locale
#
def current_locale
  I18n.locale
end

# Returns current hostname.
# If hostname is set in application configuration files, it has precedence.
# Otherwise, hostname is inferred from the +request.host+, stripped from potential
# locale name.
#
def current_hostname
  return config.hostname! if config.hostname?
  hostname_parts = request.host.split '.'
  hostname_parts.shift if I18n.available_locales.include?( hostname_parts.first.to_sym )
  hostname_parts.join "."
end

# xhr-conscious redirect.
#
def redirect(uri, *args)
  if request.xhr?
    if Hash === args.first
      opts = args.first
      [:error, :notice, :warning].each do |flash_key|
        flash[flash_key] = opts[flash_key] if opts[flash_key].present?
      end
    end
    halt 200, {'Content-Type' => 'text/javascript'}, "window.location.href=\"#{uri}\""
  else
    super( uri, *args )
  end
end