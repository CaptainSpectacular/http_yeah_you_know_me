require './lib/responder'

class Controller
  attr_reader :verb, :path, :protocol, :host, :port, :origin, :accept, :content_length

  def initialize(responder, request, client = nil)
    @responder      = responder
    @responder.controller = self
    @request        = request
    @client         = client
    @verb           = nil
    @path           = nil
    @protocol       = nil
    @host           = nil
    @accept         = nil
    @content_length = nil
    @origin         = nil
    @port           = nil
    @host           = nil
  end

  def route(request)
    parse
    @responder.total_reqs += 1
    case @verb
    when 'GET'  then route_get
    when 'POST' then route_post
    end
  end

  def route_get
    return @responder.word_search if @path.include?('/word_search')

    case @path
    when '/'         then @responder.diagnostics
    when '/hello'    then @responder.hello
    when '/datetime' then @responder.date_time
    when '/shutdown' then @responder.shut_down
    when '/game'     then @responder.web_game(:ok)
    else route_failure
    end
  end

  def route_post
    return route_failure if @responder.game && @path == '/start_game'

    case @path
    when '/start_game' then @responder.start_game
    when '/game'       then find_guess
    else route_failure
    end
  end

  def route_failure
    case @path
    when '/start_game'  then @responder.forbidden
    when '/force_error' then @responder.internal_error
    else @responder.not_found
    end
  end

  def parse
    @verb, @path, @protocol = @request[0].split

    @request.each do |line|
      key, value = line.split(': ')
      case key
      when 'Host'           then @host   = value
      when 'Accept'         then @accept = value
      when 'Content-Length' then @content_length = value.to_i
      end
    end

    @origin, @port = @host.split(':')
  end

  def find_word
    path.scan(/\=\w*/)[0].delete('=')
  end

  def find_guess
    body    = @client.read(content_length)
    guess   = body.scan(/\n\d\d?\r?/m)[0]
    guess ||= body.scan(/guess=.*/)[0]
    guess.delete!("guess=\n\r")
    @responder.game.guess(guess.to_i)
    @responder.web_game(:moved)
  end

end
