module ShariffBackend
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield configuration
  end

  class Configuration
    attr_accessor :consumer_key, :consumer_secret, :access_token, :access_token_secret, :cache, :cache_expire

    def initialize
      @consumer_key = 'CONSUMER_KEY'
      @consumer_secret = 'CONSUMER_SECRET'
      @access_token = 'ACCESS_TOKEN'
      @access_token_secret = 'ACCESS_TOKEN_SECRET'
      @cache = true
      @cache_expire = 24.hour
    end
  end
end
