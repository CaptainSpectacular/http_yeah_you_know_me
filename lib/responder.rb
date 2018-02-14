require './lib/tracker'
require './lib/parser'
require './lib/router'

class Responder

  def self.diagnostics(parser)
    <<~HEREDOC
      Verb: #{parser.verb}
      Path: #{parser.path}
      Protocol: #{parser.protocol}
      Host: #{parser.host}
      Port: #{parser.port}
      Origin: #{parser.origin}
      Accept: #{parser.accept}
    HEREDOC
  end

  def self.shut_down
    "Total Requests: #{Tracker.total_reqs}"
  end

  def self.date_time
    Time.new.strftime('%l:%M on %A, %m %e, %Y')
  end

  def self.hello
    Tracker.hellos += 1
    "Hello World (#{Tracker.hellos})"
  end

  def self.word_search(parser)
    word = parser.find_word
    dict = File.read('/usr/share/dict/words')

    case dict.include?(word)
    when true  then "#{word.upcase} is a known word"
    when false then "#{word.upcase} is not a known word"
    end
  end

  def self.start_game
    Tracker.game = Game.new
    "Good luck!"
  end

  def self.game
    <<~HEREDOC
      Guess: #{Tracker.game.recent_guess}
      Guess Total: #{Tracker.game.guess_total}
      Feedback: #{Tracker.game.feedback}
    HEREDOC
  end

end
