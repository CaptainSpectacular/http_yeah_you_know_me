require_relative './test_helper'
require './lib/responder'
require './lib/tracker'
require './lib/parser'
require './lib/router'

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

    assert_equal expected, Router.route(mock)
  end

  def test_date_time
    expected = Time.new.strftime('%l:%M on %A, %m %e, %Y')

    assert_equal expected, Responder.date_time
  end

  def test_shut_down
    expected = 'Total Requests:'

    assert Responder.shut_down.include?(expected)
  end

  def test_word_search
    mock = ["GET /word_search?word=spizzerinctum HTTP/1.1",
            "User-Agent: Faraday v0.14.0",
            "Accept-Encoding: gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
            "Accept: */*",
            "Connection: close",
            "Host: localhost:9292",
            "GET / HTTP/1.1"]

    assert_equal 'SPIZZERINCTUM is a known word', Router.route(mock)
  end

  def test_game_start
    assert_equal 'Good luck!', Responder.start_game
  end

  def test_game
    Tracker::game = Game.new
    expected = <<~HEREDOC
                    Guess: #{Tracker::game.recent_guess}
                    Guess Total: #{Tracker::game.guess_total}
                    Feedback: #{Tracker::game.feedback}
                  HEREDOC

    assert_equal expected, Responder.game
  end
end