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
  t_attrs = attrs.map{|k,v| v.nil? ? " #{k}" : " #{k}=\"#{h(v)}\""}
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

# Creates <a href=''..>...</a> tag.
#
def link_to( url, text = url, opts = {} )
  tag :a, text, opts.merge( href: url )
end

# Creates a <button ...>...</button> tag.
#
def button_to( url, text = url, opts = {} )
  tag :button, text, opts.merge( url: url )
end
