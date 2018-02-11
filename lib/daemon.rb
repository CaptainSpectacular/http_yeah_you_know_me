require 'socket'
require './lib/responder'
require 'pry'

class Daemon
  attr_reader :port

  def initialize(port)
    @port = port
  end

  def listen
    server = TCPServer.new(@port)
    client = server.accept
    until server.closed?
      request   = build_request(client)
      responder = Responder.new(request)
      response, headers = responder.respond
      client.write(headers)
      client.write(response)
      if response.include?('Requests made:')
        server.close
        Global.reps         = 0
        Global.net_requests = 0
      end
    end
  end

  def build_request(client)
    request = []
    while line = client.gets and !line.chomp.empty?
      request << line.chomp
    end
    parse(request)
  end

  def parse(request)
    verb, path, protocol = request[0].split
    host, origin, accept = nil, 'Origin: 127.0.0.1', nil
    request[1..-1].each do |item|
      key, value = item.split(': ')
      case key
      when 'Host'   then host   = [key, value].join(': ')
      when 'Origin' then origin = [key, value].join(': ')
      when 'Accept' then accept = [key, value].join(': ')
      end
    end
    
    <<~HEREDOC
      Verb: #{verb}
      Path: #{path}
      Protocol: #{protocol}
      #{host}
      Port: #{port}
      #{origin}
      #{accept}
      HEREDOC
  end
end
