require 'minitest/autorun'
require 'minitest/pride'
require './lib/responder'
require './lib/tracker'

class ResponderTest < Minitest::Test

  def test_hello_response
    expected = 'Hello World (0)'

    assert_equal expected, Responder.hello
  end

  def test_diagnostics
    mock = ["GET / HTTP/1.1",
            "User-Agent: Faraday v0.14.0",
            "Accept-Encoding: gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
            "Accept: */*",
            "Connection: close",
            "Host: localhost:9292",
            "GET / HTTP/1.1"]

    expected = <<~HEREDOC
                Verb: GET
                Path: /
                Protocol: HTTP/1.1
                Host: localhost:9292
                Port: 9292
                Origin: localhost
                Accept: */*
               HEREDOC

    assert_equal expected, Responder.respond(mock)
  end
end