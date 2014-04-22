desc "Start development console session"
task :console do
  require 'pry'
  Pry.quiet = true
  Moped.logger = Logger.new STDOUT
  app = Aerogel::Application
  binding.pry
end