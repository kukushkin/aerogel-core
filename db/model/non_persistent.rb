# NonPersistent is used as a base class for models which should not be saved to database.
# Such models can still have fields and validations.
#
# A good example is a user registration form.
#

class NonPersistent
  include Mongoid::Document

  before_save do
    raise "Attempt to save non-persistent model"
  end
end
