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
