require 'minitest/autorun'
require 'minitest/pride'
require 'socket'
require './lib/web_server'

class WebServerTest < Minitest::Test

  def test_web_server_exists_with_port
    web = WebServer.new(9292)

    assert_instance_of WebServer, web
    assert_equal 9292, web.port
  end

end