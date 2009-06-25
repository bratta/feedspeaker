# This module contains methods that will be called by a binary
# or by rake. It is the public interface (so to speak) of the
# logic for the other classes.

module FeedSpeaker
  
  # Fetch the feeds and read any unread entries
  def FeedSpeaker.speak
    feed_urls = FeedSpeaker::Config.main['feeds']
    feed_urls.each do |feed_url|
      fetcher = FeedFetcher.new(feed_url)
      fetcher.parse_feed
      read_unread_items(feed_url)
    end
  end
  
  # Select X-number of unread items for this particular feed,
  # where X is the "speak_only" config item from feeds.yml.
  # This is so that if your RSS feed contains a ton of entries
  # the TTS won't be reading all afternoon. That would get 
  # annoying really quick.
  def FeedSpeaker.read_unread_items(feed_url)
    voice = FeedSpeaker::Config.main['voice'].downcase.to_sym
    new_feeds = SimpleRssFeed.find(:all, 
      :conditions => { :feed_url => feed_url, :read => false }, 
      :order => 'created_at DESC', 
      :limit => FeedSpeaker::Config.main['speak_only'].to_i
    )
    new_feeds.each do |feed|
      Mac::TTS.say("New Story from #{feed.feed_title}", voice)
      Mac::TTS.say(feed.title, voice)
      sleep 1
      Mac::TTS.say(feed.description, voice)
      sleep 1
    end
    # We may be ignoring some entries, so mark all read
    mark_all_read(feed_url)
  end
  
  def FeedSpeaker.mark_all_read(feed_url)
    feeds = SimpleRssFeed.find_all_by_feed_url(feed_url)
    feeds.each { |f| f.read = true; f.save }
  end
  
  def FeedSpeaker.mark_all_unread(feed_url)
    feeds = SimpleRssFeed.find_all_by_feed_url(feed_url)
    feeds.each { |f| f.read = false; f.save }
  end
  
  def FeedSpeaker.force_all_unread
    FeedSpeaker::Config.main['feeds'].each do |feed|
      mark_all_unread(feed)
    end
  end
  
  def FeedSpeaker.force_all_read
    FeedSpeaker::Config.main['feeds'].each do |feed|
      mark_all_read(feed)
    end
  end
end