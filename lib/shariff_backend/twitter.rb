require 'httpclient'
require 'json'

module ShariffBackend
  # Simple share-count retrieval from Twitter
  module Twitter
    TWITTER_BASE_URL = 'http://urls.api.twitter.com/1/urls/count.json?url='

    def self.count(url)
      encoded = URI.escape(TWITTER_BASE_URL + url)
      response = HTTPClient.new.get(encoded)
      parse(response) if response.ok?
    end

    def self.parse(response)
      json = JSON.parse(response.body)
      json['count']
    end
  end
end
