module Aerogel::Helpers

  # Creates tag.
  #
  def tag( name, *args, &block )
    if block_given?
      content = output_capture(&block)
    elsif args.first.is_a? String
      content = args.shift
    end
    attrs = args.shift || {}
#    t_attrs = attrs.map{|k,v| v.nil? ? " #{k}" : " #{k}=\"#{h(v)}\""}
    t_attrs = attrs.map{|k,v| v.nil? ? " #{k}" : " #{k}=\"#{(v)}\""}
    if content
      output = "<#{name}#{t_attrs.join}>"+content+"</#{name}>"
    else
      output = "<#{name}#{t_attrs.join}/>"
    end
    if Aerogel::Render::OutputBuffer.block_is_template?(block)
      output_concat(output)
      return nil
    else
      return output
    end
  end


end # module Aerogel::Helpers
