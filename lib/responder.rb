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
    split   = request.split("\n")
    _, path = split[1].split(": ")
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
end