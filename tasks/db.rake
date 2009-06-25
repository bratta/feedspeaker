require 'active_record'  
require 'yaml'
  
namespace :db do
  desc "Migrate the database through scripts in db/migrate. Target specific version with VERSION=x"  
  task :migrate do  
    ActiveRecord::Base.establish_connection(YAML::load(File.open('config/database.yml')))  
    ActiveRecord::Base.logger = Logger.new(File.open('log/database.log', 'a'))    
    ActiveRecord::Migrator.migrate('db/migrate', ENV["VERSION"] ? ENV["VERSION"].to_i : nil )  
  end 
end

namespace :feeds do
  desc "Mark all feeds unread"
  task :mark_unread do
    FeedSpeaker.force_all_unread
  end
  
  desc "Mark all feeds read"
  task :mark_read do
    FeedSpeaker.force_all_read
  end
end