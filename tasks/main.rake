require 'lib/feedspeaker'

desc "Speak the latest RSS entries"
task :speak do
  FeedSpeaker.speak
end