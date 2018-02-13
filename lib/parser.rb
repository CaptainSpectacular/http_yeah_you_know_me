class Parser
  attr_reader :verb, :path, :protocol, :host, :port, :origin, :accept

  def initialize(request)
    @verb, @path, @protocol = request[0].split

    request.each do |line|
      key, value = line.split(': ')
      case key
      when 'Host'   then @host   = value
      when 'Accept' then @accept = value
      end
    end

    @origin, @port = @host.split(':')
  end

  def find_word
    word = path.scan(/\=\w*/)[0].delete('=')
    word.upcase
  end

end