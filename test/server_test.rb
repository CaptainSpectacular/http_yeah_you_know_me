require 'minitest/autorun'
require 'minitest/pride'
require 'faraday'
require './lib/server'
require './lib/tracker'

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

  def test_get_game_and_start_game
    Tracker::game = Game.new
    expected = <<~HEREDOC
                  Guess: #{Tracker::game.recent_guess}
                  Guess Total: #{Tracker::game.guess_total}
                  Feedback: #{Tracker::game.feedback}
                HEREDOC

    assert_equal expected, Faraday.get('http://localhost:9292/game').body
  end

  def test_post_game
    skip
    Tracker::game = Game.new
    expected = <<~HEREDOC
                  Guess: #{Tracker::game.recent_guess}
                  Guess Total: #{Tracker::game.guess_total}
                  Feedback: #{Tracker::game.feedback}
                HEREDOC
    
    Faraday.post('http://localhost:9292/game', 'guess = 50')

    assert_equal expected, Faraday.post('http://localhost:9292/game').body
  end
end
