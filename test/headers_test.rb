require_relative './test_helper'
require './lib/headers'

class HeadersTest < Minitest::Test

  def test_default_headers
    expected = ["http/1.1 200 ok",
                "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
                "server: ruby",
                "content-type: text/html; charset=iso-8859-1",
                "content-length: 12\r\n\r\n"].join("\r\n")

    assert_equal expected, Headers.default('twelve chars')
  end
end
