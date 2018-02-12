module Global
  class << self
    attr_accessor :hello, :net_requests, :guess_total
  end
end

Global.hello        = -1
Global.net_requests = 0
Global.guess_total  = 0