require 'minitest/autorun'
require 'minitest/pride'
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

  def test_get_game
    assert_equal "You're in the GET game!", Faraday.get('http://localhost:9292/game').body
  end

  def test_post_game
    assert_equal "You're in the POST game!", Faraday.post('http://localhost:9292/game').body
  end

  def test_start_game
    assert_equal "You're in the start_game!", Faraday.post('http://localhost:9292/start_game').body
  end

end
