def icon( name, opts = {} )
  icon_family = name.split('-').first
  opts[:class] = "#{icon_family} #{name}"
  opts[:style] ||= "vertical-align: middle"
  tag :i, "", opts
end
