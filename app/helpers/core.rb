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
#
def current_url
  request.path_info
end


# xhr-conscious redirect.
#
def redirect(uri, *args)
  if request.xhr?
    halt 200, {'Content-Type' => 'text/javascript'}, "window.location.href=\"#{uri}\""
  else
    super( uri, *args )
  end
end