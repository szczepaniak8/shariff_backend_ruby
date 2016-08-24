require 'twitter'
require 'json'

module ShariffBackend
  # Simple share-count retrieval from Twitter
  module Twitter

    def self.count(url)
      ::Twitter::REST::Client.new do |config|
        config.consumer_key        = ShariffBackend.configuration.consumer_key
        config.consumer_secret     = ShariffBackend.configuration.consumer_secret
        config.access_token        = ShariffBackend.configuration.access_token
        config.access_token_secret = ShariffBackend.configuration.access_token_secret
      end.search(url).count
    rescue
      0
    end
  end
end
