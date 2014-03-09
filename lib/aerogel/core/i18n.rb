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
  end

end # module Aerogel::I18n