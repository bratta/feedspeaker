class CreateSimpleRssFeeds < ActiveRecord::Migration  
  def self.up  
    create_table :simple_rss_feeds, :force => true do |t|  
      t.string  :guid
      t.string  :feed_url
      t.string  :feed_title
      t.string  :title
      t.text    :description
      t.string  :url
      t.boolean :read
      t.timestamps
    end  
  end  
  
  def self.down  
    drop_table :simple_rss_feeds 
  end  
end