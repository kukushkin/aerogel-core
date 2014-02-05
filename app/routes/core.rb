get "/" do
  view :index
end

get "/:action" do
  view params['action'] rescue raise Sinatra::NotFound.new
end

not_found do
  erb :"errors/404.html", layout: false
end
