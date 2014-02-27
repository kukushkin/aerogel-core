def icon( name, opts = {} )
  icon_family = name.split('-').first
  #  tag :i, "", opts.merge( class: "#{icon_family} #{name}", style: "vertical-align: middle" )
  tag :i, "", opts.merge( class: "#{icon_family} #{name}" )
end
