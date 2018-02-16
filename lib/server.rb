require 'socket'
require './lib/requestor'
require './lib/headers'
require './lib/controller'

class Server
  attr_reader :port
  
  def initialize(port)
    @port      = port
    @client    = nil
    @responder = Responder.new
    @requestor = Requestor.new
  end

  def listen
    daemon = TCPServer.new(port)
    loop do
      @client = daemon.accept
      request = @requestor.build(@client)

      process(request)
    end
  end

  def process(request)
    controller         = Controller.new(@responder, request, @client)
    response_body, tag = controller.route(request)
    tag              ||= :ok
    headers            = Headers.headers(response_body, tag)
    respond(headers, response_body)
  end

  def respond(headers, response)
    @client.write(headers)
    @client.write(response)
    @client.close
    shutdown(daemon) if response.include?('Total Requests:')
  end

  def shutdown(daemon)
    daemon.close
    @responder.hellos     = -1
    @responder.total_reqs = 0
    @responder.game       = nil
  end
end