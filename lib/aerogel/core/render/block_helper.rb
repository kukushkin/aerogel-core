#
# BlockHelper
# Template level helper.
# Base class for DSL magic in view helpers.
#

module Aerogel::Render

class BlockHelper

  # Creates a block helper object.
  # args will be passed to the block as arguments.
  #
  def initialize( *args, &block )
    @args = args
    @block = block

    # makes methods and helpers accessible at the self instance scope
    @self_before_instance_eval = eval "self", @block.binding
  end

  # Wraps captured content with custom tags or text.
  # Most of the time, method should be redefined by descendant class.
  # A good example would be a form helper, that surrounds captured content with <form ..></form> tags.
  #
  def wrap( content )
    content
  end

  # Renders output to the template or returns it as a string.
  #
  def render
    content = output_capture(@block) do
      instance_exec( *@args, &@block )
    end
    content_wrapped = output_capture() { wrap( content ) }
    output_concat content_wrapped
  end

  def method_missing(method, *args, &block)
    @self_before_instance_eval.send method, *args, &block
  end

end # class BlockHelper

end # module Aerogel::Render
