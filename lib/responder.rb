require './lib/tracker'
require './lib/parser'
require 'pry'
class Responder

  def self.respond(request)
    Tracker.total_reqs += 1
    @parser = Parser.new(request)
    return word_search if @parser.path.include?('/word_search')

    case @parser.path
    when '/'         then diagnostics
    when '/hello'    then hello
    when '/datetime' then date_time
    when '/shutdown' then shut_down
    end
  end

  def self.diagnostics
    <<~HEREDOC
      Verb: #{@parser.verb}
      Path: #{@parser.path}
      Protocol: #{@parser.protocol}
      Host: #{@parser.host}
      Port: #{@parser.port}
      Origin: #{@parser.origin}
      Accept: #{@parser.accept}
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

  def self.word_search
    word = @parser.find_word
    dict = File.read('/usr/share/dict/words')

    case dict.include?(word)
    when true  then "#{word} is a known word"
    when false then "#{word} is not a known word"
    end
  end
end
