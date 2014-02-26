require 'twitter'
require 'yaml'

fn = File.dirname(File.expand_path(__FILE__)) + '/credentials.yml'
credentials = YAML::load(File.open(fn))

client = Twitter::REST::Client.new(credentials)

# have we already replied to this user?
def already_replied? client, tweet
  client.user_timeline("crustasianwill").any?{|my_tweet|
    my_tweet.in_reply_to_user_id == tweet.user.id
  }
end

def random_phrase
  fn = File.dirname(File.expand_path(__FILE__)) + '/phrases.yml'
  YAML::load(File.open(fn)).sample
end

# -rt excludes retweets
tweet = client.search('lobster for dinner -rt', result_type: 'recent').
               take(1).first

unless already_replied?(client, tweet)
  # without the @username in the tweet, the conversation doesn't appear
  # on twitter
  client.update "@#{tweet.user.screen_name} #{random_phrase}",
                in_reply_to_status_id: tweet.id.to_s
end
