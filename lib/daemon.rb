require 'socket'
require 'pry'

class Daemon
  attr_reader :port

  def initialize(port)
    @port = port
  end

  def listen
    rep = 0
    Socket.tcp_server_loop(port) do |client|
      request = build_request(client)

      response = "<html><head></head><body><pre> Hello World! (#{rep}) </pre></body>#{request}</html>"

      headers = ["http/1.1 200 ok",
                 "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
                 "server: ruby",
                 "content-type: text/html; charset=iso-8859-1",
                 "content-length: #{response.length}\r\n\r\n"]
                 .join("\r\n")

      client.write(headers)
      client.write(response)
      rep += 1
      client.close
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
    
    ["Verb: #{verb}",
     "Path: #{path}",
     "Protocol: #{protocol}", 
      host,
     "Port: #{port}",
      origin,
      accept]
  end
end
