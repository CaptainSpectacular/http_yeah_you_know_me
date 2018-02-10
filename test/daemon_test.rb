require 'minitest/autorun'
require 'minitest/pride'
require 'socket'
require 'faraday'
require './lib/daemon'

class WebServerTest < Minitest::Test

  def test_daemon_exists_with_port
    daemon = Daemon.new(9292)

    assert_instance_of Daemon, daemon
    assert_equal 9292, daemon.port
  end

  def test_daemon_listens_and_provides_feedback
    daemon = Daemon.new(9292)
    daemon.listen

    assert_equal "Hello World! (0)", Faraday.get('http://localhost:9292').body
    assert_equal "Hello World! (1)", Faraday.get('http://localhost:9292').body
    assert_equal "Hello World! (2)", Faraday.get('http://localhost:9292').body
  end
end