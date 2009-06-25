# This program fetches RSS feeds and will audibly read them to you,
# keeping track of which ones have been read. It will also allow 
# you to specifiy a number of items to read so if your RSS feed 
# is busy, it won't be reading to you all afternoon. 
#
# It uses the bratta-mactts gem from github as well as a lot of 
# other utilities to make it play nice, such as ActiveRecord.
#
# Author:: Tim Gourley
# Copyright:: Copyright (C) 2009 Tim Gourley.
# License:: This application is protected under the GNU GPL v3

$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))
  
require 'rubygems'
require 'rss'
require 'open-uri'
require 'sanitize'
require 'htmlentities'
require 'mactts'
require 'yaml'
require 'active_record'
require 'logger'  
require 'feedspeaker/utilities'
require 'feedspeaker/simple_rss_feed'
require 'feedspeaker/feed_fetcher'
require 'feedspeaker/feedspeaker'

