# Mixin module for all model classes.
#
module Model
  extend ActiveSupport::Concern

  def self.redefined_field_types
    @redefined_field_types ||= {}
  end

  def self.define_field_type( type, method_name )
    redefined_field_types[type] = method_name.to_sym
  end

  module ClassMethods

    # Finds document by id.
    # Raises error if document is not found.
    #
    def find!( *args )
      raise_not_found_error_was = Mongoid.raise_not_found_error
      begin
        Mongoid.raise_not_found_error = true
        self.find( *args )
      ensure
        Mongoid.raise_not_found_error = raise_not_found_error_was
      end
    end

    # ...
    # other class methods can be defined inside Model::ClassMethods by aerogel modules
    # ...

  end # module ClassMethods

  included do
    include Mongoid::Document

    class << self
      alias_method :define_field_mongoid, :field
    end

    # Defines native Mongoid field or calls field type handler
    # in case of redefined field types.
    #
    def self.field( name, opts = {} )
      if opts[:type] && Model.redefined_field_types.key?( opts[:type] )
        self.send Model.redefined_field_types[opts[:type]], name, opts
      else
        self.define_field_mongoid( name, opts )
      end
    end

    extend ClassMethods
  end

  module NonPersistent
    extend ActiveSupport::Concern
    included do
      include Mongoid::Document
      before_save do
        raise "Attempt to save non-persistent model"
      end
    end
  end # module NonPersistent

  module Timestamps
    extend ActiveSupport::Concern
    included do
      include Mongoid::Timestamps
    end
  end # module Timestamps

end # module Model