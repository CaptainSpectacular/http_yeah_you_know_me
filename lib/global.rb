module Global
  class << self
    attr_accessor :hello, :net_requests
  end
end

Global.hello        = -1
Global.net_requests = 0
