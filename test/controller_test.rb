require_relative './test_helper'
require './lib/controller'

class ControllerTest < Minitest::Test

  def setup
    @request =["GET /word_search?word=barnacle HTTP/1.1",
              "User-Agent: Faraday v0.14.0",
              "Accept-Encoding: gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
              "Accept: */*",
              "Connection: close",
              "Host: localhost:9292",
              "GET / HTTP/1.1",
              "Content-Length: 8"]

    @responder = Responder.new
    @responder.game = Game.new
    @client = File.open('./test/controller_client_test.txt')
    @controller = Controller.new(@responder, @request, @client)
    @controller.parse
  end

  def test_existance
    assert_instance_of Controller, @controller
  end

  def test_parse_method_works
    assert_equal 'GET', @controller.verb
    assert_equal '/word_search?word=barnacle', @controller.path
    assert_equal 'HTTP/1.1', @controller.protocol
    assert_equal 'localhost:9292', @controller.host
    assert_equal 'localhost', @controller.origin
    assert_equal '9292', @controller.port
    assert_equal '*/*', @controller.accept
  end

  def test_find_word_method
    assert_equal 'barnacle', @controller.find_word
  end

  def test_find_guess_method
    body = <<~HEREDOC
              Guess: -2
              Guess Total: 1
              Feedback: Too low!
            HEREDOC
    expected = [body, :moved]
            
    assert_equal expected, @controller.find_guess
  end

  def test_route_method
    assert_equal 'BARNACLE is a known word', @controller.route(@request)
  end
end