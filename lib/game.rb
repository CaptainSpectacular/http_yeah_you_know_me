class Game
  attr_accessor :master_number
  attr_reader :feedback
  def initialize
    @master_number = rand(1..100)
    @feedback      = nil
  end

  def guess(num)
    case num <=> @master_number
    when  1 then @feedback = "#{num} is too high!"
    when  0 then @feedback = "That's the right number!"
    when -1 then @feedback = "#{num} is too low!"
    end
  end

end