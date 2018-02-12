require 'minitest/autorun'
require 'minitest/pride'
require 'faraday'
require './lib/server'

class ServerTest < Minitest::Test
  
  def test_server_exists_and_has_port
    server = Server.new(9191)

    assert_instance_of Server, server
    assert_equal 9191, server.port
  end

end