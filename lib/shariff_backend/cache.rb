require 'httpclient'
require 'json'
require 'as-duration'
require 'shariff_backend/configuration'

module ShariffBackend
  module Cache
    @data =  {}
    @expires = ShariffBackend.configuration.nil? ? 2.second : ShariffBackend.configuration.cache_expire

    def self.get(key)
      @data[key.to_s][:value] if self.exist?(key) && !self.expires?(key)
    end

    def self.set(key, value = nil)
      check_key!(key)
      @data[key.to_s] = {
        value: block_given? ? yield : value,
        timestamp: Time.now
      }
      @data[key.to_s][:value]
    end

    def self.unset(key)
      check_key!(key)
      @data.delete(key.to_s)
    end

    def self.exist?(key)
      check_key!(key)
      @data.keys.include?(key.to_s)
    end

    def self.get_or_set(key, value = nil)
      return get(key) if exist?(key) and not expires?(key)
      set(key, block_given? ? yield : value)
    end

    private 

    def self.expires?(key)
      return false unless self.exist?(key)
      (Time.now - @data[key.to_s][:timestamp]).to_i > @expires.to_i
    end

    def self.check_key!(key)
      unless key.is_a?(String) || key.is_a?(Symbol)
        raise TypeError, "key must be a String or Symbol"
      end
    end
  end
end
