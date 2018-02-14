require 'socket'
require './lib/requestor'
require './lib/headers'
require './lib/tracker'
require './lib/router'

class Server
  attr_reader :port
  
  def initialize(port)
    @port = port
  end

  def listen
    daemon = TCPServer.new(port)
    loop do
      client = daemon.accept

      request       = Requestor.build(client)
      response_body = Router.route(request, client)
      headers       = Headers.default(response_body)

      client.write(headers)
      client.write(response_body)
      client.close
      shutdown(daemon) if response_body.include?('Total Requests:')
    end
  end

  def shutdown(daemon)
    daemon.close
    Tracker::hellos     = -1
    Tracker::total_reqs = 0
    Tracker::game       = nil
  end
end