require 'mongoid'
require 'aerogel/configurator'
require 'aerogel/core/db/model'

module Aerogel::Db

  class << self
    # List of registered models
    attr_accessor :models, :environment
  end

  # Registers and configures database access
  #
  def self.registered( app )
    self.environment = app.environment
    raise "Database connection is not configured in your application's config/*" if Aerogel.config.db.nil?
    Mongoid.configure do |config|
      config.sessions = {
        default: { hosts: Aerogel.config.db.hosts, database: Aerogel.config.db.name }
      }
      config.options = {
        raise_not_found_error: false
      }
    end
    load_models

    # register reloader
    setup_reloader(app) if Aerogel.config.aerogel.reloader

    # disable [deprecated] warning in Mongoid method calls
    I18n.enforce_available_locales = false if defined? I18n
  end

  # Perform database migration
  #
  def self.migrate!
    create_indexes!
  end

  # Clears database.
  #
  def self.clear!
    puts "* clearing database"
    models.each do |model_class|
      puts "** destroing all objects in #{model_class.name}"
      model_class.destroy_all
    end
    puts "* purging database"
    Mongoid.purge!
  end

  # Seeds database.
  #
  def self.seed!
    load_and_process_seeds!
  end

private

  # Loads all models from the folder db/model/*
  #
  def self.load_models
    reset!
    Aerogel.get_resource_list( 'db/model', '**/*.rb' ) do |full_filename, model_filename, path|
      puts "** loading model: #{path} #{model_filename}"
      load full_filename
      # puts "** classify: #{class_name}"
      self.models << filename_to_model( model_filename )
    end
  end

  # Resets models.
  #
  def self.reset!(app = nil)
    self.models ||= []
    # reset model classes
    self.models.uniq.each do |model|
      model.parent.send(:remove_const, model.name.demodulize.to_sym)
    end
    self.models = []
  end

  #
  # Configures reloader for models.
  #
  def self.setup_reloader(app)
    app.use Aerogel::Reloader, ->{ Aerogel.get_resource_list( "db/model", "**/*.rb" ) } do
      reset!(app)
      load_models
    end
  end


  # Create database indexes for all models
  #
  def self.create_indexes!
    models.each do |model_class|
      puts "* creating/updating indexes for: #{model_class.name}"
      model_class.create_indexes
    end
  end

  # Loads and processes seed files.
  #
  def self.load_and_process_seeds!
    seed_files = Aerogel.get_resource_list( 'db/seed', '*.seed', environment )
    seed_files.each do |seed_file|
      load_and_process_single_seed! seed_file
    end
  end

  # Load and process a single seed file.
  #
  def self.load_and_process_single_seed!( seed_filename )
    puts "* processing seeds from: #{seed_filename}"
    created_num = 0
    updated_num = 0
    seed = Configurator.new seed_filename
    raise ArgumentError, "'model' is not specified" if seed.model.nil?
    raise ArgumentError, "'find_by' is not specified" if seed.find_by.nil?
    seeds = seed.seeds || []
    raise ArgumentError, "'seeds' should be Array" unless seeds.is_a? Array

    seed.find_by = [ seed.find_by ] unless seed.find_by.is_a? Array
    seed.force = [ seed.force ] unless seed.force.is_a? Array
    seeds.each do |fields|
      obj_keys = Hash[ seed.find_by.map{|k| [k, fields[k]] } ]
      obj_where = seed.model.where( obj_keys )
      if obj_where.count > 1
        puts "!!! WARNING: more than one object found for: #{seed.model.name}: #{humanize_seed_keys obj_keys}"
        puts "    first found object is used."
      end
      obj = obj_where.first
      if obj
        # exclude default and key attributes
        fields.delete_if do |k,v|
          !seed.force.include?( k ) && ( !obj[k].nil? || obj_keys.include?(k) )
        end
        if fields.size > 0
          obj.update_attributes! fields
          updated_num += 1
        end
      else
        seed.model.create! fields
        created_num += 1
      end
    end
    puts " - #{created_num} created / #{updated_num} updated"
  end

  # Returns humanized search condition.
  #
  def self.humanize_seed_keys( obj_keys )
    obj_keys.map{|k,v| "#{k}:'#{v}'"}.join(', ')
  end

  # Returns class object inferred from filename.
  #
  def self.filename_to_model( filename )
    filename.chomp('.rb').split("/").map(&:camelize).join("::").constantize
  end

end # module Aerogel::Db

