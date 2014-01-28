require 'sinatra/asset_pipeline/task'
require 'aerogel/core'

Aerogel::Application.load
Sinatra::AssetPipeline::Task.define! Aerogel::Application

# require *.rake tasks from /rake folder
Aerogel.get_resource_list( :rake, '*.rake' ).each do |taskname|
  load taskname
end