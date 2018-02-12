require './lib/global'
require './lib/daemon'
require 'pry'
class Responder
  attr_reader :request

  def initialize(request)
    @request = request
  end

  def respond
    Global.net_requests += 1
    response = check_path(request)
    headers  = ["http/1.1 200 ok",
               "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
               "server: ruby",
               "content-type: text/html; charset=iso-8859-1",
               "content-length: #{response.length}\r\n\r\n"]
               .join("\r\n")

    [response, headers]
  end

  def check_path(request)
    spliced = request.split("\n")
    path = spliced[1].split(": ")[1]
    return word_search if path.include?("word_search")
    case path
    when '/'         then return diagonistics
    when '/hello'    then return hello_world
    when '/datetime' then return date_time
    when '/shutdown' then return shutdown
    end
  end

  def diagonistics
    @request
  end

  def hello_world
    Global.reps += 1
    "Hello World! (#{Global.reps})"
  end

  def date_time
    Time.now.strftime('%I:%M%p on %A, %B %d, %Y')
  end

  def shutdown
    "Requests made: #{Global.net_requests.to_s}"
  end

  def word_search
    word = request.split("\n")[1].split('?word=')[1]
    dictionary = File.read('/usr/share/dict/words')
    if dictionary.split("\n").include?(word)
      "#{word.upcase} is a known word"
    else
      "#{word.upcase} is not a known word"
    end
  end
end