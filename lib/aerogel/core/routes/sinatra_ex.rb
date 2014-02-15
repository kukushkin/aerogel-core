# A helper method to reset Sinatra routes.
#
class Sinatra::Base
  class << self
    def reset_routes!
      @routes = {}
      @filters = {:before => [], :after => []}
      @errors = {}
    end
  end
end # class Sinatra::Base