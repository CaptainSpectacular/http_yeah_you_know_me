require_relative './test_helper'
require './lib/requestor'


class RequestorTest < Minitest::Test

  def test_build_response
    requestor = Requestor.new
    client   = File.open('./test/requestor_test.txt')
    actual = requestor.build(client)
    expected = ["GET / HTTP/1.1",
                "User-Agent: Faraday v0.14.0",
                "Accept-Encoding: gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
                "Accept: */*",
                "Connection: close",
                "Host: localhost:9292",
                "GET / HTTP/1.1"]
    
    assert_equal expected[0], actual[0]
    assert_equal expected[1], actual[1]
    assert_equal expected[3], actual[3]
  end

end