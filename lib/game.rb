class Game
  attr_reader :guess_total  
  def initialize
    @master_number = rand(1..100)
    @guess_total   = 0
    @guess         = nil
  end

  def guess(num)
    case num <=> master_number
    when  1 then return 'Too high!'
    when  0 then return 'You got it! Good job.'
    when -1 then return 'Too low!'
  end

end