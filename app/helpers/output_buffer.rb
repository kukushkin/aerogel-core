def output_concat( text )
  if self.respond_to?(:is_haml?) && is_haml?
    haml_concat(text)
  elsif !Aerogel::Render::OutputBuffer.buffer.nil? # has_erb_buffer?
    Aerogel::Render::OutputBuffer.buffer.concat text
  else # theres no template to concat, return the text directly
    text
  end
end

def output_capture( inner_block = nil, &block )
  inner_block = block if inner_block.nil?
  if self.respond_to?(:is_haml?) && is_haml? && (block_is_haml?(inner_block) rescue false)
    # haml
    capture_haml(nil, &block)
  elsif Aerogel::Render::OutputBuffer.block_is_erb? block
    # erb
    Aerogel::Render::OutputBuffer.capture( &block )
  else
    block.call
  end
end
