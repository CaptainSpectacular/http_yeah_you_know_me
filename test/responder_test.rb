require 'minitest/autorun'
require 'minitest/pride'
require './lib/responder'
require './lib/tracker'

class ResponderTest < Minitest::Test

  def test_hello_response
    expected = 'Hello World (0)'

    assert_equal expected, Responder.hello
  end
end