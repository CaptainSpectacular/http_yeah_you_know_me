require './lib/responder'
require './lib/parser'

class Router

  def initialize(responder, client = nil)
    @responder = responder
    @client    = client
    @parser    = Parser.new
  end

  def route(request)
    @parser.set(request)
    @responder.total_reqs += 1
    case @parser.verb
    when 'GET'  then route_get
    when 'POST' then route_post
    end
  end

  def route_get
    return @responder.word_search(@parser) if @parser.path.include?('/word_search')

    case @parser.path
    when '/'         then @responder.diagnostics(@parser)
    when '/hello'    then @responder.hello
    when '/datetime' then @responder.date_time
    when '/shutdown' then @responder.shut_down
    when '/game'     then @responder.web_game
    else route_failure
    end
  end

  def route_post
    return route_failure if @responder.game && @parser.path == '/start_game'

    case @parser.path
    when '/start_game' then @responder.start_game
    when '/game'       then @responder.game.guess(@parser.find_guess(@client)) &&
                            @responder.web_game
    else route_failure
    end
  end

  def route_failure
    case @parser.path
    when '/start_game'  then @responder.forbidden
    when '/force_error' then @responder.internal_error
    else @responder.not_found
    end
  end
end
