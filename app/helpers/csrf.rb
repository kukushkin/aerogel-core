def csrf_field_name
  'authenticity_token'
end

def csrf_token
  session[:csrf] ||= SecureRandom.hex(32) if defined?(session)
end

def csrf_token_field
  tag :input, type: 'hidden', name: csrf_field_name, value: csrf_token
end

def csrf_protected?
  true
end
