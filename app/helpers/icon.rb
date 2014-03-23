# Renders icon from icon font.
# First part of the +name+ defines icon family.
#
# Example:
#   <%= icon 'fa-caret-right' %> # => icon 'caret-right' from Font Awesome (fa) family
#   <%= icon 'glyphicon-tick' %> #=> icon 'tick' from Boostrap glyphicons
#
def icon( name, opts = {} )
  icon_family = name.split('-').first
  icon_class = "#{icon_family} #{name} #{opts[:class]}"
  tag :i, "", opts.merge( class: icon_class )
end
