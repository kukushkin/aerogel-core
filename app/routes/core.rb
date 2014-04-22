# serve static files
get "/*" do |filename|
  pass if filename.blank?
  path = Aerogel.get_resource( :public, filename )
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
  begin
    view params['action']
  rescue Errno::ENOENT
    pass
  end
end

not_found do
  erb :"errors/404.html", layout: false
end
