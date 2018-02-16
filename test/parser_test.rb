require_relative './test_helper'
require './lib/parser'


class ParserTest < Minitest::Test

  def setup
    @request =["GET /find_word?word=barnacle HTTP/1.1",
              "User-Agent: Faraday v0.14.0",
              "Accept-Encoding: gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
              "Accept: */*",
              "Connection: close",
              "Host: localhost:9292",
              "GET / HTTP/1.1",
              "Content-Length: 8"]

     @client = File.open('./test/parser_client_test.txt')
     @parser = Parser.new
     @parser.set(@request)
  end

  def test_existance
    assert_instance_of Parser, @parser
  end

  def test_attributes
    assert_equal 'GET', @parser.verb
    assert_equal '/find_word?word=barnacle', @parser.path
    assert_equal 'HTTP/1.1', @parser.protocol
    assert_equal 'localhost:9292', @parser.host
    assert_equal 'localhost', @parser.origin
    assert_equal '9292', @parser.port
    assert_equal '*/*', @parser.accept
  end

  def test_find_word_method
    assert_equal 'barnacle', @parser.find_word
  end

  def test_find_guess_method
    assert_equal 78, @parser.find_guess(@client)
  end
end