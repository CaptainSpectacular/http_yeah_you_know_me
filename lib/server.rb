require 'socket'

class Server

  attr_reader :port
  def initialize(port)
    @port = port
  end

end
