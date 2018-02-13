class Game
  attr_accessor :master_number
  attr_reader :recent_guess, :feedback, :guess_total
  def initialize
    @master_number = rand(1..100)
    @guess_total   = 0
    @recent_guess  = nil
    @feedback      = nil
  end

  def guess(num)
    @guess_total += 1
    @recent_guess = num
    case num <=> @master_number
    when  1 then @feedback = 'Too high!'
    when  0 then @feedback = 'That\'s correct!'
    when -1 then @feedback = 'Too low!'
    end
  end
end
