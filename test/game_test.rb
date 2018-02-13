require 'minitest/autorun'
require 'minitest/pride'
require './lib/game'

class GameTest < Minitest::Test

  def test_game_exists
    game = Game.new

    assert_instance_of Game, game
  end

  def test_game_has_master_number
    game = Game.new
    game.master_number = 50
    
    assert_equal 50, game.master_number
  end

  def test_game_feedback
    game = Game.new
    game.master_number = 50

    game.guess(25)

    assert_equal '25 is too low!', game.feedback

    game.guess(75)

    assert_equal '75 is too high!', game.feedback

    game.guess(50)

    assert_equal "That's the right number!", game.feedback
  end

end