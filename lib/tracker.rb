require './lib/game'

module Tracker
  class << self
    attr_accessor :hellos, :total_reqs, :game
  end
end

Tracker::total_reqs =  0
Tracker::hellos     = -1
Tracker::game       = nil