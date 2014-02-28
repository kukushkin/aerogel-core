get "/*" do |filename|
  pass if filename.blank?
  path = Aerogel.get_resource( :public, filename )
  puts "Serving static file: '#{path}' or not?"
  pass unless path
  pass unless File.file? path
  send_file path
end
