require_relative './test_helper'
require './lib/headers'

class HeadersTest < Minitest::Test

  def test_default_headers
    expected = ["http/1.1 200 ok",
                "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
                "server: ruby",
                "content-type: text/html; charset=iso-8859-1",
                "content-length: 12\r\n\r\n"].join("\r\n")

    assert_equal expected, Headers.headers('twelve chars', :ok)
  end

  def test_other_headers
    forbidden = ["http/1.1 403 Forbidden",
                "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
                "server: ruby",
                "content-type: text/html; charset=iso-8859-1",
                "content-length: 12\r\n\r\n"].join("\r\n")

    not_found = ["http/1.1 404 Not Found",
                "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
                "server: ruby",
                "content-type: text/html; charset=iso-8859-1",
                "content-length: 12\r\n\r\n"].join("\r\n")

    moved = ["http/1.1 302 Moved Permanently",
             "Location: http://localhost:9292/start_game",
             "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
             "server: ruby",
             "content-type: text/html; charset=iso-8859-1",
             "content-length: 12\r\n\r\n"].join("\r\n")

    error = ["http/1.1 500 Internal Server Error",
             "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
             "server: ruby",
             "content-type: text/html; charset=iso-8859-1",
             "content-length: 12\r\n\r\n"].join("\r\n")
    
    assert_equal forbidden, Headers.headers('twelve chars', :forbidden)
    assert_equal not_found, Headers.headers('twelve chars', :not_found)
    assert_equal moved, Headers.headers('twelve chars', :moved)
    assert_equal error, Headers.headers('twelve chars', :error)
  end
end
