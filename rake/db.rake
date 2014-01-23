# dummy task for command line 'force' parameter
task :force

namespace :db do

desc "Create database"
task :create do
  abort "Not implemented"
end

desc "Clear database"
task :clear do |t, args|
  forced = ARGV.include? 'force'
  if Aerogel::Application.environment == :production and not forced
    abort "Clearing database in production environment is dangerous, use: 'rake db:<taskname> force'"
  end
  Aerogel::Db.clear!
  puts "DONE"
end

desc "Seed database"
task :seed do
  Aerogel::Db.seed!
  puts "DONE"
end

desc "Migrate database"
task :migrate do
  Aerogel::Db.migrate!
  puts "DONE"
end

desc "Migrate & seed database"
task :update => [:migrate, :seed]

desc "Re-creates database"
task :recreate => [:clear, :migrate, :seed]


end # namespace :db
