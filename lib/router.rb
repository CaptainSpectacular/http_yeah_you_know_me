require './lib/responder'
require './lib/parser'

class Router

  def self.route(request)
    Tracker.total_reqs += 1
    @parser = Parser.new(request)

    return Responder.word_search(@parser) if @parser.path.include?('/word_search')

    case @parser.path
    when '/'         then Responder.diagnostics(@parser)
    when '/hello'    then Responder.hello
    when '/datetime' then Responder.date_time
    when '/shutdown' then Responder.shut_down
    end
  end

end