require './lib/tracker'
class Responder

  def self.respond(request)
    hello
  end

  def self.hello
    Tracker.hellos += 1
    "Hello World (#{Tracker.hellos})"
  end
end