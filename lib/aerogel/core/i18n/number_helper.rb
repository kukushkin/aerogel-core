module Aerogel::I18n
  module NumberHelper

    def number_with_delimiter(number, options = {})
       options.symbolize_keys!

       options[:delimiter] = ERB::Util.html_escape(options[:delimiter]) if options[:delimiter]
       options[:separator] = ERB::Util.html_escape(options[:separator]) if options[:separator]

       begin
         Float(number)
       rescue ArgumentError, TypeError
         if options[:raise]
           raise # InvalidNumberError, number
         else
           return number
         end
       end

       defaults = ::I18n.translate(:'number.format', :locale => options[:locale], :default => {})
       options = options.reverse_merge(defaults)

       parts = number.to_s.to_str.split('.')
       parts[0].gsub!(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1#{options[:delimiter]}")
       parts.join(options[:separator]).html_safe

     end

    DECIMAL_UNITS = {0 => :unit, 1 => :ten, 2 => :hundred, 3 => :thousand, 6 => :million, 9 => :billion, 12 => :trillion, 15 => :quadrillion,
           -1 => :deci, -2 => :centi, -3 => :mili, -6 => :micro, -9 => :nano, -12 => :pico, -15 => :femto}

    def number_with_precision(number, options = {})
      options.symbolize_keys!

      number = begin
        Float(number)
      rescue ArgumentError, TypeError
        if options[:raise]
          raise # InvalidNumberError, number
        else
          return number
        end
      end

      defaults           = ::I18n.translate(:'number.format', :locale => options[:locale], :default => {})
      precision_defaults = ::I18n.translate(:'number.precision.format', :locale => options[:locale], :default => {})
      defaults           = defaults.merge(precision_defaults)

      options = options.reverse_merge(defaults)  # Allow the user to unset default values: Eg.: :significant => false
      precision = options.delete :precision
      significant = options.delete :significant
      strip_insignificant_zeros = options.delete :strip_insignificant_zeros

      if significant and precision > 0
        if number == 0
          digits, rounded_number = 1, 0
        else
          digits = (Math.log10(number.abs) + 1).floor
          rounded_number = (BigDecimal.new(number.to_s) / BigDecimal.new((10 ** (digits - precision)).to_f.to_s)).round.to_f * 10 ** (digits - precision)
          digits = (Math.log10(rounded_number.abs) + 1).floor # After rounding, the number of digits may have changed
        end
        precision -= digits
        precision = precision > 0 ? precision : 0  #don't let it be negative
      else
        rounded_number = BigDecimal.new(number.to_s).round(precision).to_f
      end
      formatted_number = number_with_delimiter("%01.#{precision}f" % rounded_number, options)
      if strip_insignificant_zeros
        escaped_separator = Regexp.escape(options[:separator])
        formatted_number.sub(/(#{escaped_separator})(\d*[1-9])?0+\z/, '\1\2').sub(/#{escaped_separator}\z/, '').html_safe
      else
        formatted_number
      end

    end

    STORAGE_UNITS = [:byte, :kb, :mb, :gb, :tb]

    # TODO: use NumberHelper from 'activesupport ~> 4.0',
    # at the moment it is incompatible with mongoid,
    #
    #
    def number_to_human_size(number, options = {})
      options.symbolize_keys!

      number = begin
        Float(number)
      rescue ArgumentError, TypeError
        if options[:raise]
          raise # InvalidNumberError, number
        else
          return number
        end
      end

      defaults = ::I18n.translate(:'number.format', :locale => options[:locale], :default => {})
      human    = ::I18n.translate(:'number.human.format', :locale => options[:locale], :default => {})
      defaults = defaults.merge(human)

      options = options.reverse_merge(defaults)
      #for backwards compatibility with those that didn't add strip_insignificant_zeros to their locale files
      options[:strip_insignificant_zeros] = true if not options.key?(:strip_insignificant_zeros)

      storage_units_format = ::I18n.translate(:'number.human.storage_units.format', :locale => options[:locale], :raise => true)

      base = options[:prefix] == :si ? 1000 : 1024

      if number.to_i < base
        unit = ::I18n.translate(:'number.human.storage_units.units.byte', :locale => options[:locale], :count => number.to_i, :raise => true)
        storage_units_format.gsub(/%n/, number.to_i.to_s).gsub(/%u/, unit).html_safe
      else
        max_exp  = STORAGE_UNITS.size - 1
        exponent = (Math.log(number) / Math.log(base)).to_i # Convert to base
        exponent = max_exp if exponent > max_exp # we need this to avoid overflow for the highest unit
        number  /= base ** exponent

        unit_key = STORAGE_UNITS[exponent]
        unit = ::I18n.translate(:"number.human.storage_units.units.#{unit_key}", :locale => options[:locale], :count => number, :raise => true)

        formatted_number = number_with_precision(number, options)
        storage_units_format.gsub(/%n/, formatted_number).gsub(/%u/, unit).html_safe
      end
    end

  end # module NumberHelper
end # module Aerogel::I18n