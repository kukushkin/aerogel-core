require 'r18n-core'

# Aerogel::I18n provides localization support for aerogel applications.
#
module Aerogel::I18n

  def self.registered(app)
    # load locales
    locale_paths = Aerogel.get_resource_paths( :locales ).reverse
    # app.register Sinatra::R18n
    R18n.default_places = locale_paths

    # register reloader
    setup_reloader(app) if Aerogel.config.aerogel.reloader?
  end

  # Gets or sets current locale.
  #
  def self.locale( new_value = nil )
    @current_locale ||= :en # TODO: set default locale from configs
    if new_value
      @current_locale = new_value
      R18n.set @current_locale
    end
    @current_locale
  end

  # Sets current locale
  #
  def self.locale=( new_value )
    locale( new_value )
  end

private

  # Sets up reloader for locales.
  #
  def self.setup_reloader(app)
    app.use Aerogel::Reloader, ->{ Aerogel.get_resource_list( :locales, "*.*" ) } do |files|
      locale_paths = Aerogel.get_resource_paths( :locales ).reverse
      R18n.default_places = locale_paths
      R18n.get.reload!
      R18n.clear_cache!
    end
  end

end # module Aerogel::I18n