# Global rendering buffer.
# Output capture functionality for ERb and Haml blocks.
#
module Aerogel::Render
module OutputBuffer

  # Returns instance of a string buffer
  #
  def self.buffer
    @buffer
  end

  # Sets instance of a string buffer
  #
  def self.buffer=( text )
    @buffer = text
  end

  # Saves current buffer in a stack and creates a new empty one.
  #
  def self.push
    @buffer_stack ||= []
    @buffer_stack.unshift @buffer
    @buffer = ''
  end

  # Returns current buffer contents as a string and restores previous
  # buffer state from a stack.
  #
  def self.pop
    result = @buffer
    @buffer = @buffer_stack.shift
    result
  end

  # Executes block and captures content rendered into buffer.
  # If no content is rendered into buffer, returns block yield result as a content.
  #
  def self.capture(*args, &block)
    self.push
    blk_result = yield *args
    buf_result = self.pop
    buf_result.nil? || buf_result.empty? ? blk_result : buf_result
  end

  # Returns true if block is defined within a ERb template.
  #
  def self.block_is_erb?( block )
    !@buffer.nil? || block && eval('defined? __in_erb_template', block.binding)
  end

  # Returns true if block is defined within a ERb template.
  #
  def self.block_is_haml?( block )
    block && eval('block_is_haml?(self)', block.binding)
  end

  # Returns true if block is defined within any template.
  #
  def self.block_is_template?( block )
    block && ( block_is_erb?(block) || block_is_haml?( block ) )
  end

end # module OutputBuffer
end # module Aerogel::Render

