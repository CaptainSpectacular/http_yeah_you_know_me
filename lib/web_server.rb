# This is the WebServer server class. Handles HTTP requests.
class WebServer
  attr_reader :port

  def initialize(port)
    @port = port
  end

end