$LOAD_PATH.push File.expand_path('../../lib', __FILE__)

require 'cutest'
require 'webmock'
require 'rr/without_autohook'

require 'shariff_backend/twitter'

include WebMock::API

scope do
  def url_to_test
    'https://marcusilgner.com'
  end

  setup do
    WebMock.disable_net_connect!
    stub_request(:get, "http://urls.api.twitter.com/1/urls/count.json?url=#{url_to_test}")
      .to_return(body: '{"count": 432, "url": "http:\/\/marcusilgner.com\/"}')
  end

  test 'Twitter' do
    count = ShariffBackend::Twitter.count(url_to_test)
    assert_equal(432, count)
  end
end
