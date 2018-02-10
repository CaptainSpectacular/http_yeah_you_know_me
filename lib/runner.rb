require_relative './daemon'

class Runner
  def self.start
    daemon = Daemon.new(9292)
    daemon.listen 
  end
end
