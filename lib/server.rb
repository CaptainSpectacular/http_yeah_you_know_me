require 'socket'
require './lib/requestor'
require './lib/headers'
require './lib/router'

class Server
  attr_reader :port
  
  def initialize(port)
    @port      = port
    @responder = Responder.new
    @requestor = Requestor.new
  end

  def listen
    daemon = TCPServer.new(port)
    loop do
      client = daemon.accept
      request            = @requestor.build(client)
      router             = Router.new(@responder, client)
      response_body, tag = router.route(request)
      tag              ||= :ok
      headers            = Headers.headers(response_body, tag)

      client.write(headers)
      client.write(response_body)
      client.close
      shutdown(daemon) if response_body.include?('Total Requests:')
    end
  end

  def shutdown(daemon)
    daemon.close
    @responder.hellos     = -1
    @responder.total_reqs = 0
    @responder.game       = nil
  end
end