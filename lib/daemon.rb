require 'socket'
require './lib/responder'
require './lib/requestor'
require 'pry'

class Daemon
  attr_reader :port

  def initialize(port)
    @port = port
  end

  def listen
    server = TCPServer.new(@port)
    loop do
      client    = server.accept
      request   = Requestor.build_request(client)
      responder = Responder.new(request)
      response, headers = responder.respond
      client.write(headers)
      client.write(response)
      client.close
      shutdown(server) && break if response.include?('Requests made:')
    end
  end

  def shutdown(server)
    server.close
    Global.reps         = -1
    Global.net_requests = 0
  end
end
