module Aerogel
module Errors

  module Translated
    def initialize( *args )
      @translation_key = nil
      if args.first.is_a? Symbol
        @translation_key = args.shift
      end
      super( *args )
    end

    def to_s
      if @translation_key
        Aerogel::I18n.t @translation_key, scope: 'errors.messages'
      else
        super
      end
    end
  end # module Translated

  class NotFoundError < StandardError
    include Translated
  end # class NotFoundError

  class InvalidOperationError < StandardError
    include Translated
  end # class InvalidOperationError

end # module Errors
end # module Aerogel

include Aerogel::Errors