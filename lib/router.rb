require './lib/responder'
require './lib/parser'

class Router

  def self.route(request)
    Tracker.total_reqs += 1
    @parser = Parser.new(request)

    case @parser.verb
    when 'GET'  then route_get
    when 'POST' then route_post
    end
  end

  def self.route_get
    return Responder.word_search(@parser) if @parser.path.include?('/word_search')

    case @parser.path
    when '/'         then Responder.diagnostics(@parser)
    when '/hello'    then Responder.hello
    when '/datetime' then Responder.date_time
    when '/shutdown' then Responder.shut_down
    when '/game'     then Responder.get_game
    end
  end

  def self.route_post
    case @parser.path
    when '/start_game' then Responder.start_game
    when '/game'       then Responder.post_game
    end
  end

end