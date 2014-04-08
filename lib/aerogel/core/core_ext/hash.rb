#
# Core extensions to Hash.
#

class Hash

  # defined in ActiveSupport: #except, #except!

  # Returns hash containing only elements listed in +args+.
  #
  def only( *keys )
    self.select{|key,v| [*keys].include? key }
  end

  # Modifies and returns hash containing only elements listed in +args+.
  #
  def only!( *keys )
    self.select!{|key,v| [*keys].include? key }
    self
  end

  # Returns hash containing all elements except those with specified +keys+.
  #
  def except( *keys )
    dup.except!( *keys )
  end

  # Modifies and returns hash containing all elements except those with specified +keys+.
  #
  def except!( *keys )
    keys.each do |k|
      if String === k || Symbol === k
       delete k.to_sym
       delete k.to_s
      else
        delete k
      end
    end
    self
  end

  # Returns Hash converted to a string of HTML tag attributes.
  #
  def to_html_params
    self.map{|n, v| v.nil? ? "#{n}" : "#{n}=\"#{v}\""}.join(" ")
  end

end # class Array