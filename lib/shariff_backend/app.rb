require 'cuba'

module ShariffBackend
  # Cuba/Rack application which routes the requests to the providers
  class App < ::Cuba
    PROVIDERS = [Facebook, Twitter]

    def provider_name(provider)
      name = provider.name.split('::').last || provider.name
      name.downcase
    end

    def all_provider_data(url)
      PROVIDERS.map do |provider|
        [provider_name(provider), provider.count(url)]
      end
    end

    define do
      on get do
        # Requests to the root return counts from all providers
        on root, param('url') do |url|
          data = Hash[all_provider_data(url)]
          res.write(JSON.dump(data))
        end

        # It's also possible to query providers individually
        PROVIDERS.each do |provider|
          on provider_name(provider), param('url') do |url|
            res.write(provider.count(url))
          end
        end
      end
    end
  end
end
