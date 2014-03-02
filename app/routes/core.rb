# serve static files
get "/*" do |filename|
  pass if filename.blank?
  path = Aerogel.get_resource( :public, filename )
  puts "Serving static file: '#{path}' or not?"
  pass unless path
  pass unless File.file? path
  send_file path
end

# serve default root
get "/" do
  view :index
end

# serve default root actions
get "/:action" do
  view params['action'] # rescue raise Sinatra::NotFound.new
end

not_found do
  erb :"errors/404.html", layout: false
end
