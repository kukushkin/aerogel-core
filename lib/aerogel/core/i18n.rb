require 'i18n'

# Aerogel::I18n provides localization support for aerogel applications.
#
module Aerogel::I18n

  def self.registered(app)
    # load locales
    reload!

    # register reloader
    setup_reloader(app) if Aerogel.config.aerogel.reloader?
  end


  # Translation helper with chainable key access support.
  # You can call #t using standard i18n way:
  #
  #   t 'aerogel.admin.welcome', username: 'John'
  #
  # Or using aerogel syntactic sugar:
  #
  #   t.aerogel.admin.welcome username: 'John'
  #
  def self.t( *args )
    if args.size > 0
      puts "** I18n.t original t: #{args}"
      ::I18n.t( *args )
    else
      puts "** I18n.t chainable t: #{args}"
      Chainable.new( *args )
    end
  end

  def self.l( *args )
    ::I18n.l( *args )
  end

  def self.locale( *args )
    ::I18n.locale( *args )
  end

  def self.locale=( *args )
    ::I18n.send :'locale=', *args
  end

  def self.default_locale
    ::I18n.default_locale
  end
  def self.available_locales
    ::I18n.available_locales
  end

private

  # Sets up reloader for locales.
  #
  def self.setup_reloader(app)
    app.use Aerogel::Reloader, ->{ get_locale_files } do |files|
      reload! files
    end
  end

  # Returns list of locale translation files.
  #
  def self.get_locale_files
    Aerogel.get_resource_list( :locales, "**/*.yml" )
  end

  # Reload locales.
  #
  def self.reload!( files = nil )
    ::I18n.load_path = files || get_locale_files
    ::I18n.reload!
    ::I18n.default_locale = Aerogel.config.locales.default! if Aerogel.config.locales.default?
    ::I18n.available_locales = Aerogel.config.locales.enabled! if Aerogel.config.locales.enabled?
  end


  # Chainable #t helper support class.
  # Example:
  #   t.aerogel.admin.welcome # => t 'aerogel.admin.welcome'
  #   t.aerogel.admin.welcome username: 'John' # => t 'aerogel.admin.welcome', username: 'John'
  #
  class Chainable
    def initialize( *args )
      @path = []
      call( *args ) if args.size > 0
    end

    def method_missing( name, *args )
      @path << name.to_sym
      if args.size > 0
        call( *args )
      else
        self
      end
    end

    def call( *args )
      ::I18n.t translation_key, *args
    end

    def to_s()
      ::I18n.t translation_key
    end

    def translation_key
      @path.join(".")
    end
  end # class Chainable

end # module Aerogel::I18n