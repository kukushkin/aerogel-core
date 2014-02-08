# Mixin module for all model classes.
#
module Model
  extend ActiveSupport::Concern

  included do
    include Mongoid::Document

    # Finds document by id.
    # Raises error if document is not found.
    #
    def self.find!( *args )
      raise_not_found_error_was = Mongoid.raise_not_found_error
      begin
        Mongoid.raise_not_found_error = true
        self.find *args
      ensure
        Mongoid.raise_not_found_error = raise_not_found_error_was
      end
    end

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

end # module Model