require 'httpclient'
require 'json'

module ShariffBackend
  # Retrieves share count for LinkedIn
  module LinkedIn
    LINKEDIN_BASE_URL = 'https://www.linkedin.com/countserv/count/share?lang=de_DE&format=json&url='

    def self.count(url)
      encoded = URI.escape(LINKEDIN_BASE_URL + url)
      response = HTTPClient.new.get(encoded)
      parse(response) if response.ok?
    end

    def self.parse(response)
      json = JSON.parse(response.body)
      json['count']
    end
  end
end
