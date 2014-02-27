#
# Core extensions to Array.
#

class Array

  # Returns array with excluded elements.
  #
  def except( *args )
    self - [ *args ]
  end

  # Modifies and returns array with excluded elements.
  #
  def except!( *args )
    self.replace( self.except! *args )
  end

  # Returns array containing only elements listed in +args+.
  #
  def only( *args )
    self & [*args]
  end

  # Modifies and returns array containing only elements listed in +args+.
  #
  def only!( *args )
    self.replace( self.only *args )
  end


end # class Array