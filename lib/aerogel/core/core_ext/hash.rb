#
# Core extensions to Hash.
#

class Hash

  # defined in ActiveSupport: #except, #except!

  # Returns hash containing only elements listed in +args+.
  #
  def only( *args )
    self.select{|key,v| [*args].include? key }
  end

  # Modifies and returns hash containing only elements listed in +args+.
  #
  def only!( *args )
    self.select!{|key,v| [*args].include? key }
    self
  end

end # class Array