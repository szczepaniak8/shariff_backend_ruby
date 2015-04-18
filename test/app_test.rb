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

  scope 'root' do
    setup do
      RR.mock(ShariffBackend::Facebook).count(URL_TO_TEST) { 123 }
      RR.mock(ShariffBackend::Twitter).count(URL_TO_TEST) { 432 }
      RR.mock(ShariffBackend::GooglePlus).count(URL_TO_TEST) { '> 9999' }
      RR.mock(ShariffBackend::LinkedIn).count(URL_TO_TEST) { 8 }
    end

    test 'returns all data' do
      get "/?url=#{URL_TO_TEST}"
      assert(last_response.body.length > 10)
      parsed = JSON.parse(last_response.body)
      assert(parsed.key?('facebook'))
      assert_equal(parsed['facebook'], 123)
      assert(parsed.key?('twitter'))
      assert_equal(parsed['twitter'], 432)
      assert(parsed.key?('googleplus'))
      assert_equal(parsed['googleplus'], '> 9999')
      assert(parsed.key?('linkedin'))
      assert_equal(parsed['linkedin'], 8)
    end
  end

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

  scope 'Google+' do
    setup do
      RR.mock(ShariffBackend::GooglePlus).count(URL_TO_TEST) { '> 9999' }
    end

    test 'returns "> 9999"' do
      get "/googleplus?url=#{URL_TO_TEST}"
      assert_equal '> 9999', last_response.body
    end
  end

  scope 'LinkedIn' do
    setup do
      RR.mock(ShariffBackend::LinkedIn).count(URL_TO_TEST) { 8 }
    end

    test 'returns 8' do
      get "/linkedin?url=#{URL_TO_TEST}"
      assert_equal '8', last_response.body
    end
  end
end
