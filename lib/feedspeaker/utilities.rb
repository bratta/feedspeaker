# This module contains utility methods for loading 
# configuration files, as well as connecting to the database
# It is analogous to Rails' boot.rb and environment.rb. Sort of.
# Only not as clean.

module FeedSpeaker
  class MissingFeedSpeakerConfigException < Exception; end
  
  # Load the main configuration file
  def FeedSpeaker.load_feedspeaker_yaml
    load_yaml('feeds.yml')
  end
  
  # Load the database.yml config for ActiveRecord
  def FeedSpeaker.load_database_yaml
    load_yaml('database.yml')
  end
  
  # Generic method for loading yml files from the config/ directory
  def FeedSpeaker.load_yaml(yaml_file)
    config_file = (File.expand_path("#{File.dirname(__FILE__)}/../../config/#{yaml_file}"))
    return YAML::load(File.open(config_file))
  rescue 
    raise MissingFeedSpeakerConfigException, "Cannot find a valid config/#{yaml_file} file!"    
  end
  
  # Class designed to hold the config data
  class Config
    @main = FeedSpeaker.load_feedspeaker_yaml
    @db   = FeedSpeaker.load_database_yaml
    
    class << self; attr_reader :main, :db; end
  end
end

# Connect to the database and set up the log
ActiveRecord::Base.establish_connection(FeedSpeaker::Config.db)
ActiveRecord::Base.logger = Logger.new(File.open(File.expand_path("#{File.dirname(__FILE__)}/../../log/database.log"), 'a'))
