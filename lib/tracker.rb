require './lib/game'

module Tracker
  class << self
    attr_accessor :hellos, :total_reqs, :game
  end
end

Tracker.hellos     = -1
Tracker.total_reqs = 0
Tracker.game       = nil
