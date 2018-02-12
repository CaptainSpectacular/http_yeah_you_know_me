require 'socket'

class Server

  attr_reader :port
  def initialize(port)
    @port = port
  end

  def listen
    daemon = TCPServer.new(port)
    hello = 0
    loop do

      client = daemon.accept
      request = []

      response = "Hello World (#{hello})"

      headers = ["http/1.1 200 ok",
          "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
          "server: ruby",
          "content-type: text/html; charset=iso-8859-1",
          "content-length: #{response.length}\r\n\r\n"].join("\r\n")

      while line = client.gets and !line.chomp.empty?
        request << line.chomp
      end

      hello += 1
      client.write(headers)
      client.write(response)
      client.close

    end
  end
end
