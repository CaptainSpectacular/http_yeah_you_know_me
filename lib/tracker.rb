module Tracker
  class << self
    attr_accessor :hellos, :total_reqs
  end
end

Tracker.hellos     = -1
Tracker.total_reqs = 0