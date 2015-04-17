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

scope do
  def url_to_test
    'https://marcusilgner.com'
  end

  setup do
    WebMock.disable_net_connect!
    RR.mock(ShariffBackend::Facebook).count(url_to_test) { 123 }
  end

  test 'Facebook' do
    get "/facebook?url=#{url_to_test}"
    assert_equal '123', last_response.body
  end
end
