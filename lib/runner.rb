require './lib/server'

class Runner

  def self.start
    server = Server.new(9292)
    server.listen
  end

end