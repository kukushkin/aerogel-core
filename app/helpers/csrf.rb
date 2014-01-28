module Aerogel::Helpers

  def csrf_field_name
    'authenticity_token'
  end

  def csrf_token
    session[:csrf] ||= SecureRandom.hex(32) if defined?(session)
  end

  def csrf_token_field
    input_hidden_tag csrf_field_name, csrf_token
  end

  def csrf_protected?
    true
  end

end # module Aerogel::Helpers
