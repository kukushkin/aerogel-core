#
# Core extensions to Array.
#

class Array

  # Returns array with excluded elements.
  #
  def except( *args )
    self - [ *args ]
  end

end # class Array