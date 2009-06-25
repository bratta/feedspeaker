# This class is responsible for pulling the RSS feed down from
# a specified source (@feed_url) and parsing it. The logic implies
# that if the specific RSS item has not been saved to the database
# previously, go ahead and create a SimpleRssFeed object for it
# and persist it to the database.
#
# The class also cleans up content by removing HTML tags and 
# unescaping htmlentities, making it easier for the Mac text-to-
# speech program to read it.

class FeedFetcher
  attr_accessor :feed_url
  
  def initialize(feed_url = nil)
    @feed_url = feed_url
  end
  
  def parse_feed
    items = Array.new
    open(@feed_url) do |feed|
      rss = RSS::Parser.parse(feed.read, false)
      feed_title = stripper(rss.channel.title)
      rss.items.each do |i|
        # Don't save it if we've already saved it. The guid
        # should be unique, according to the RSS spec.
        # Note that this is very simple and won't work for
        # all RSS feeds (it doesn't care about version or Atom feeds)
        if SimpleRssFeed.find_all_by_guid(i.guid.content).length == 0
          item = SimpleRssFeed.new do |f|
            f.guid        = i.guid.content
            f.feed_url    = @feed_url
            f.feed_title  = feed_title
            f.title       = stripper(i.title)
            f.description = stripper(i.description)
            f.url         = i.link
            f.read        = false
          end
          item.save
          items << item
        end
      end
    end
    items  # return our array of saved RSS entries
  end
  
  private 
  
  # No class is complete without its own private stripper
  def stripper(text)
    coder = HTMLEntities.new
    coder.decode(Sanitize.clean(text))
  end
end