if config.locales.guess_from_hostname?

  before do
    default_locale = I18n.default_locale
    request_locale = request.host.split(".").first.to_sym
    locale = I18n.available_locales.include?( request_locale ) ? request_locale : default_locale
    if locale == default_locale && config.hostname? && request.host != config.hostname
      redirect current_url( locale: default_locale )
      # flash[:debug] = "redirecto to canonical: #{current_url( locale: default_locale )}"
    end
    I18n.locale = locale
  end

end # config.locales.guess_from_hostname?