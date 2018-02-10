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
      output = "Hello World! (#{rep})"
      headers = ["http/1.1 200 ok",
                 "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
                 "server: ruby",
                 "content-type: text/html; charset=iso-8859-1",
                 "content-length: #{output.length}\r\n\r\n"].join("\r\n")
      client.write(headers)
      client.write(output)
      rep += 1
      client.close
    end
  end
end
