require_relative './test_helper'
require 'faraday'
require './lib/server'

class ServerTest < Minitest::Test
  
  def test_server_exists_and_has_port
    server = Server.new(9191)

    assert_instance_of Server, server
    assert_equal 9191, server.port
  end

  def test_server_listens_on_port
    server = Server.new(9191)

    assert_equal 'Hello World (0)', Faraday.get('http://localhost:9292/hello').body
    assert_equal 'Hello World (1)', Faraday.get('http://localhost:9292/hello').body
    assert_equal 'Hello World (2)', Faraday.get('http://localhost:9292/hello').body
  end

  def test_server_diagnostics_page
    expected = <<~HEREDOC
                Verb: GET
                Path: /
                Protocol: HTTP/1.1
                Host: localhost:9292
                Port: 9292
                Origin: localhost
                Accept: */*
               HEREDOC
    

    assert_equal expected, Faraday.get('http://localhost:9292/').body
  end

  def test_server_date_time
    expected = Time.new.strftime('%l:%M on %A, %m %e, %Y')

    assert_equal expected, Faraday.get('http://localhost:9292/datetime').body
  end

  def test_word_search
    assert_equal 'SPIZZERINCTUM is a known word', Faraday.get('http://localhost:9292/word_search?word=spizzerinctum').body
    assert_equal 'FARQUAD is not a known word', Faraday.get('http://localhost:9292/word_search?word=farquad').body
  end

  def test_start_game
    assert_equal "Good luck!", Faraday.post('http://localhost:9292/start_game').body
  end

  def test_game_requests
    Faraday.post('http://localhost:9292/start_game')
    Faraday.post('http://localhost:9292/game', { 'guess' => '-1' })

    expected = <<~HEREDOC
                  Guess: -1
                  Guess Total: 1
                  Feedback: Too low!
                HEREDOC

    assert_equal expected, Faraday.get('http://localhost:9292/game').body
  end

  def test_error_codes
    skip
    Faraday.post('http://localhost:9292/start_game')

    assert_equal 'Page not found', Faraday.post('http://localhost:9292/hello').body
    assert_equal 404, Faraday.post('http://localhost:9292/hello').status

    assert_equal 'Forbidden', Faraday.post('http://localhost:9292/start_game').body
    assert_equal 403, Faraday.post('http://localhost:9292/start_game').status

    assert_equal 'Moved Permanently', Faraday.post('http://localhost:9292/game', {'guess'=>'-1'}).body
    assert_equal 302, Faraday.post('http://localhost:9292/game', {'guess'=>'43'}).status
  end
end
