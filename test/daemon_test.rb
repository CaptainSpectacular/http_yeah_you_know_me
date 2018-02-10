require 'minitest/autorun'
require 'minitest/pride'
require 'socket'
require 'faraday'
require './lib/runner'

class DaemonTest < Minitest::Test

  def test_daemon_exists_with_port
    daemon = Daemon.new(9191)

    assert_instance_of Daemon, daemon
    assert_equal 9191, daemon.port
  end

  def test_daemon_listens_and_provides_feedback
    assert_equal 'Hello World! (0)', Faraday.get('http://localhost:9292').body.split("\n")[0]
    assert_equal 'Hello World! (1)', Faraday.get('http://localhost:9292').body.split("\n")[0]
    assert_equal 'Hello World! (2)', Faraday.get('http://localhost:9292').body.split("\n")[0]
  end

  def test_footer_has_diagnostics
    expected = ['Verb: GET',
                'Path: /',
                'Protocol: HTTP/1.1',
                'Host: localhost:9292',
                'Port: 9292',
                'Origin: 127.0.0.1',
                'Accept: */*']
    
    assert_equal expected[0], Faraday.get('http://localhost:9292').body.split("\n")[1]
    assert_equal expected[1], Faraday.get('http://localhost:9292').body.split("\n")[2]
    assert_equal expected[2], Faraday.get('http://localhost:9292').body.split("\n")[3]
    assert_equal expected[3], Faraday.get('http://localhost:9292').body.split("\n")[4]
    assert_equal expected[4], Faraday.get('http://localhost:9292').body.split("\n")[5]
    assert_equal expected[5], Faraday.get('http://localhost:9292').body.split("\n")[6]
  end

  def test_routes_between_pages
    assert_equal 'Hello World! (0)', Faraday.get('http://localhost:9292/hello').body
    assert_equal 'Verb: GET', Faraday.get('http://localhost:9292').body.split("\n")[0]
    assert_equal 'somehow test the date and time', Faraday.get(('http://localhost:9292/datetime').body.split("\n")[0]
    assert_equal '4', Faraday.get(('http://localhost:9292/shutdown').body.split("\n")[0]
    # test that the server is no longer operational after /shutdown
  end
end