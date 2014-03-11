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
  opts.present? ? url_to( url, opts ) : url
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

# Constructs an URL to a resource.
#
# Options passed in +opts+ will be appended to URL as a query string,
# except some reserved options which have special meaning:
#   :locale => constructs URL with a certain locale
#   :scheme => constructs URL with a certain protocol
#   :fqdn => constructs full qualified URL, including hostname and protocol
#
# Example:
#   url_to "/bar", locale: :de, page: 2, order: :name # => "http://de.example.org/bar?page=2&order=name"
#
def url_to( url, opts = {} )
  hostname = nil
  if opts[:fqdn] || opts[:scheme]
    opts[:locale] ||= current_locale
  end
  if opts[:locale]
    unless I18n.available_locales.include? opts[:locale]
      raise ArgumentError.new("Unavailable locale '#{opts[:locale]}' passed to #url_to helper")
    end
    if opts[:locale] == I18n.default_locale
      hostname = current_hostname
    else
      hostname = "#{opts[:locale]}.#{current_hostname}"
    end
  end
  query_string = opts.except( :locale, :fqdn, :scheme ).map{|k,v| "#{k}=#{h v}"}.join "&"
  if query_string.present?
    if url =~ /\?/
      query_string = "&#{query_string}"
    else
      query_string = "?#{query_string}"
    end
  end
  scheme = opts[:scheme] || request.scheme || 'http:'
  scheme_hostname = hostname.nil? ? '' : "#{scheme}//#{hostname}"
  "#{scheme_hostname}#{url}#{query_string}"
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