require 'pry'
class Requestor

  def self.build_request(client)
    request = []
    while line = client.gets and !line.chomp.empty?
      request << line.chomp
    end
    parse(request)
  end

  def self.parse(request)
    verb, path, protocol = request[0].split
    host, origin, accept = nil, 'Origin: 127.0.0.1', nil
    request[1..-1].each do |item|
      key, value = item.split(': ')
      case key
      when 'Host'   then host   = [key, value].join(': ')
      when 'Origin' then origin = [key, value].join(': ')
      when 'Accept' then accept = [key, value].join(': ')
      end
    end
    
    <<~HEREDOC
      Verb: #{verb}
      Path: #{path}
      Protocol: #{protocol}
      #{host}
      Port: #{host.split(':t')}
      #{origin}
      #{accept}
    HEREDOC
  end

end