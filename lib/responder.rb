require './lib/Controller'
require './lib/game'

class Responder
  attr_accessor :total_reqs, :hellos, :game, :controller

  def initialize
    @total_reqs = 0
    @hellos     = -1
    @game       = nil
    @controller = nil
  end

  def diagnostics
    <<~HEREDOC
      Verb: #{@controller.verb}
      Path: #{@controller.path}
      Protocol: #{@controller.protocol}
      Host: #{@controller.host}
      Port: #{@controller.port}
      Origin: #{@controller.origin}
      Accept: #{@controller.accept}
    HEREDOC
  end

  def shut_down
    "Total Requests: #{@total_reqs}"
  end

  def date_time
    Time.new.strftime('%l:%M on %A, %m %e, %Y')
  end

  def hello
    @hellos += 1
    "Hello World (#{@hellos})"
  end

  def word_search
    word = @controller.find_word
    dict = File.read('/usr/share/dict/words')

    case dict.include?(word)
    when true  then "#{word.upcase} is a known word"
    when false then "#{word.upcase} is not a known word"
    end
  end

  def start_game
    @game = Game.new
    ["Good luck!", :moved]
  end

  def web_game(tag)
    response = <<~HEREDOC
                    Guess: #{@game.recent_guess}
                    Guess Total: #{@game.guess_total}
                    Feedback: #{@game.feedback}
                  HEREDOC
    [response, tag]
  end

  def forbidden
    ['Forbidden', :forbidden]
  end

  def not_found
    ['Page not found', :not_found]
  end

  def internal_error
    ['Internal Server Error', :error]
  end

end
