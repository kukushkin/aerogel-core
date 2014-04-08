require 'active_support/core_ext'
require 'aerogel/core/core_ext/array'
require 'aerogel/core/core_ext/hash'

module Aerogel

  class << self
    attr_accessor :core_path, :application_path
  end

  # Returns module version.
  #
  def self.version
    Aerogel::VERSION
  end

  # Registers a new path for all resource loaders.
  #
  # If type is not specified, then resource paths are formed
  # by appending type to the given path.
  #
  # If type is specified, given path is cosidered a final path
  # for this resource type, and for this resource type only.
  #
  def self.register_path( path, type = nil )
    @registered_paths ||= []
    path = File.expand_path( path )
    module_name = File.basename path
    @registered_paths << { path: path, module_name: module_name, type: type }
  end

  # Returns registered paths.
  # If type is specified, only resource paths containing this type are returned.
  #
  def self.registered_paths( type = nil )
    @registered_paths.select{|p| type.nil? || p[:type].nil? || p[:type] == type }
  end

  # Returns list of paths for specified resource type.
  #
  def self.get_resource_paths( type, &block )
    paths = []
    registered_paths( type ).each do |base_path|
      path = base_path[:type].nil? ? File.join( base_path[:path], type.to_s ) : base_path[:path]
      paths << { base_path: base_path, path: path }
      yield path, base_path if block_given?
    end
    paths.map {|p| p[:path] }
  end

  # Returns list of filenames of resources of specified type,
  # environment sub-folders included, filtered by wildcard mask.
  #
  # Resources are listed in a forward order of paths, files within each
  # path listed in alphabetic order.
  #
  # The resources are searched in following order:
  #   path1 + wildcard
  #   path1 + environment + wildcard
  #   path2 + wildcard
  #   path2 + environment + wildcard
  #   etc
  #
  def self.get_resource_list( type, wildcard, environment = nil, &block )
    resource_list = []
    get_resource_paths( type ) do |path, base_path|
      paths = Dir.glob( File.join( path, wildcard ) )
      if environment
        paths << Dir.glob( File.join( path, environment.to_s, wildcard ) )
      end
      # puts "Aerogel::get_resource_list: type=#{type} environment=#{environment} path=#{path}: #{paths}"
      if block_given?
        paths.each do |filename|
          relative_filename = filename.sub( /^#{path}\/?/, '' )
          yield filename, relative_filename, path, base_path
        end
      end
      resource_list << paths
    end
    resource_list.flatten
  end

  # Returns reversed list of filenames of resources of specified type,
  # environment sub-folders included, filtered by wildcard mask.
  #
  # Reverse order is applied to registered paths, but not to files within single path,
  # which are listed in alphabetic order.
  #
  # The resources are searched in following order:
  #   path1 + wildcard
  #   path1 + environment + wildcard
  #   path2 + wildcard
  #   path2 + environment + wildcard
  #   etc
  #
  def self.get_reverse_resource_list( type, wildcard, environment = nil )
    get_resource_paths( type ).reverse.map do |path|
      paths = Dir.glob( File.join( path, wildcard ) )
      if environment
        paths << Dir.glob( File.join( path, environment.to_s, wildcard ) )
      end
      # puts "Aerogel::get_resource_list: type=#{type} environment=#{environment} path=#{path}: #{paths}"
      paths
    end.flatten
  end

  # Returns filename of the most recent resource file of specified type.
  #
  def self.get_resource( type, filename, environment = nil )
    get_resource_list( type, filename, environment ).last
  end

  # Require resources specified by type and wildcard.
  #
  def self.require_resources( type, wildcard, environment = nil )
    files_to_require = Aerogel.get_resource_list( type, wildcard, environment )
    files_to_require.each do |filename|
      # begin
        require filename
      # rescue => e
      #  raise e # "Failed to load resource '#{filename}': #{e}"
      # end
    end
    true
  end

  # Require resources specified by type and wildcard in reverse order.
  #
  def self.require_resources_reverse( type, wildcard, environment = nil )
    files_to_require = Aerogel.get_reverse_resource_list( type, wildcard, environment )
    files_to_require.each do |filename|
      # begin
        require filename
      # rescue => e
      #  raise e # "Failed to load resource '#{filename}': #{e}"
      # end
    end
    true
  end

  # Requires file, loads into context of a module/class.
  #
  def self.require_into( mod_class, filename )
    mod_class.class_eval File.read(filename), filename
  end

  # Returns registered on-load callbacks.
  #
  def self.on_load_callbacks
    @on_load_callbacks || []
  end

  # Registers on-load callback.
  #
  def self.on_load( &block )
    @on_load_callbacks ||= []
    @on_load_callbacks << block
  end

end # module Aerogel
