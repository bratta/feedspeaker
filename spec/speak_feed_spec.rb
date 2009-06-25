require File.expand_path(File.join('.', 'spec_helper'), File.dirname(__FILE__))

describe FeedSpeaker, "When dealing with utility methods" do
  before(:each) do
  end
  
  it "should load a valid feeds.yml file" do
    FeedSpeaker.load_feedspeaker_yaml.should_not == nil
  end
  
  it "should load a valid database.yml file" do
    FeedSpeaker.load_database_yaml.should_not == nil
  end
  
end