require 'socket'
require './lib/requestor'
require './lib/responder'
require './lib/headers'

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
      response_body = Responder.respond(request)
      headers       = Headers.default(response_body)

      client.write(headers)
      client.write(response_body)
      client.close
    end
  end
end
