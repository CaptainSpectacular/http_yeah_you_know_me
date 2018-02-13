require './lib/tracker'
require './lib/parser'
class Responder

  def self.respond(request)
    Tracker.total_reqs += 1
    @parser = Parser.new(request)

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
end
