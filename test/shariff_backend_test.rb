$LOAD_PATH.push File.expand_path('../../lib', __FILE__)

require 'cutest'
require 'rack/test'
require 'webmock'

require 'shariff_backend'

# Set up Cutest to test this app
# rubocop:disable Style/ClassAndModuleChildren
module Cutest::Scope
  include Rack::Test::Methods

  def app
    ShariffBackend::App
  end
end

include WebMock::API

WebMock.disable_net_connect!

scope do
  test 'Facebook' do
    stub_request(:get, %r{\Ahttps://api.facebook.com/method/fql.query})
      .to_return(body: '[{"share_count": 123}]')

    get '/facebook?url=https://marcusilgner.com'
    assert_equal '123', last_response.body
  end
end
