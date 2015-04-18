require 'httpclient'

module ShariffBackend
  # Simple share-count retrieval from Google+
  # Since there is no official API for this, try scraping it from the HTML of the "+1 button"
  # Note that this backend can yield strings like '> 9999' instead of concrete numbers
  module GooglePlus
    BUTTON_BASE_URL = 'https://plusone.google.com/_/+1/fastbutton?url='

    def self.count(url)
      encoded = URI.escape(BUTTON_BASE_URL + url)
      response = HTTPClient.new.get(encoded)
      parse(response.body) if response.ok?
    end

    # Just grok the response with a Regex to avoid pulling in
    # expensive dependencies
    def self.parse(response)
      match_data = %r{<div [^>]*id=['"]aggregateCount['"][^>]*>([^<]+)</div>}.match(response)
      match_data ? match_data[1] : '0'
    end
  end
end
