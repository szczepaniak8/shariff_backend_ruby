require 'cuba'

module ShariffBackend
  # Cuba/Rack application which routes the requests to the providers
  class App < ::Cuba
    PROVIDERS = [Facebook, Twitter]

    def route_name(provider)
      name = provider.name.split('::').last || provider.name
      name.downcase
    end

    define do
      on get do # we only need get requests in this app
        PROVIDERS.each do |provider|
          on route_name(provider), param('url') do |url|
            res.write(provider.count(url))
          end
        end
      end
    end
  end
end
