require './lib/tracker'
require './lib/parser'
class Responder

  def self.respond(request)
    @parser = Parser.new(request)

    case @parser.path
    when '/'     then diagnostics
    when 'hello' then hello
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
      Accept: #{@parser.origin}
    HEREDOC
  end

  def self.hello
    Tracker.hellos += 1
    "Hello World (#{Tracker.hellos})"
  end
end
