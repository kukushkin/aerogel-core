
module Aerogel::Routes
class Namespace

  def initialize( base, path, &block )
    @base = base
    @prefix_path = path
    instance_eval &block
  end

  def method_missing( method, *args, &block )
    @base.send method, *args, &block
  end

  def prefixed( method, *args, &block )
    options = Hash === args.last ? args.pop : {}
    routes = [*(args.pop || '*')]
    routes, args = routes+args, [] unless method == :route
    routes.map!{|r| @prefix_path+r }
    routes = [routes] if method == :route
    p_args = []
    p_args += args unless args.empty?
    p_args += routes # unless routes.empty?
    p_args += options unless options.empty?
    @base.send method, *p_args, &block
  end

  def self.prefix( *methods )
    methods.each do |method|
      define_method(method) {|*args, &block| prefixed( method, *args, &block ) }
    end
  end

  prefix :get, :post, :put, :delete, :before, :after, :namespace, :route

end # class Namespace
end # module Aerogel::Routes
