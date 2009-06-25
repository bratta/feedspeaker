require File.expand_path(File.join('.', 'spec_helper'), File.dirname(__FILE__))

describe SimpleRssFeed, "Dealing with ActiveRecord model SimpleRssFeed" do
  it "should create a new instance" do
    @feed = SimpleRssFeed.new
    @feed.should_not == nil
  end
  
  it "should save a properly formatted feed" do
    @feed = SimpleRssFeed.new    
    @feed.guid = 'unique'
    @feed.feed_url = 'http://localhost'
    @feed.title = 'Test Feed'
    @feed.title = 'Testing from RSpec'
    @feed.description = 'This is a test from RSpec. We aint got no rspec!'
    @feed.url = 'http://localhost#testing'
    @feed.read = false
    @feed.save.should == true
  end
  
  it "should select at least one row from the db" do
    @feeds = SimpleRssFeed.find(:all)
    @feeds.length.should >= 1
  end
  
  it "should edit the latest entry" do
    @feed = SimpleRssFeed.find(:first, :order => "id DESC")
    @feed.title = 'Updated, yo!'
    @feed.save.should == true
  end
  
  it "should delete the latest entry" do
    @feed = SimpleRssFeed.find(:first, :order => 'id DESC')
    id = @feed.id
    @feed.delete
    lambda { SimpleRssFeed.find(id)}.should raise_error(ActiveRecord::RecordNotFound)
  end
end