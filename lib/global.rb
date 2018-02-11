module Global
  class << self
    attr_accessor :reps, :net_requests
  end
end

Global.reps         = 0
Global.net_requests = 0
