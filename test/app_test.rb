$LOAD_PATH.push File.expand_path('../../lib', __FILE__)

require 'cutest'
require 'rack/test'
require 'webmock'
require 'rr/without_autohook'

require 'shariff_backend'

# Set up Cutest to test this app
# rubocop:disable Style/ClassAndModuleChildren
class Cutest::Scope
  include Rack::Test::Methods

  def app
    ShariffBackend::App
  end
end

setup do
  WebMock.disable_net_connect!
end

scope do
  URL_TO_TEST = 'https://marcusilgner.com'

  scope 'Facebook' do
    setup do
      RR.mock(ShariffBackend::Facebook).count(URL_TO_TEST) { 123 }
    end

    test 'returns 123' do
      get "/facebook?url=#{URL_TO_TEST}"
      assert_equal '123', last_response.body
    end
  end

  scope 'Twitter' do
    setup do
      RR.mock(ShariffBackend::Twitter).count(URL_TO_TEST) { 432 }
    end

    test 'returns 432' do
      get "/twitter?url=#{URL_TO_TEST}"
      assert_equal '432', last_response.body
    end
  end
end
