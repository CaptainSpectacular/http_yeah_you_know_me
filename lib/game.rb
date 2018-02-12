class Game
  
  def initialize
    @master_number = rand(1..100)
    @guess = nil
  end

  def guess(num)
    case num <=> master_number
    when  1 then return 'Too high!'
    when  0 then return 'You got it! Good job.'
    when -1 then return 'Too low!'
  end

end