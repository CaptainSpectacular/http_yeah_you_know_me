require './lib/responder'
require './lib/parser'

class Router

  def self.route(request, client = nil)
    Tracker::total_reqs += 1
    @client = client
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
    when '/game'     then Responder.game
    end
  end

  def self.route_post
    # @parser.find_word
    case @parser.path
    when '/start_game' then Responder.start_game
    when '/game'       then Tracker::game.guess(@parser.find_guess(@client)) && Responder.game
    end
  end
end
