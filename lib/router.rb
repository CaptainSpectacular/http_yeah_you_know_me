require './lib/responder'
require './lib/parser'

class Router

  def self.route(request)
    @parser = Parser.new(request)
    case @parser.verb
    when 'GET'  then route_get
    when 'POST' then route_post
    end
  end

  def self.route_get
    Tracker.total_reqs += 1

    return Responder.word_search(@parser) if @parser.path.include?('/word_search')

    case @parser.path
    when '/'         then Responder.diagnostics(@parser)
    when '/hello'    then Responder.hello
    when '/datetime' then Responder.date_time
    when '/shutdown' then Responder.shut_down
    end
  end

  def self.route_post
  
  end

end