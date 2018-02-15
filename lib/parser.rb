class Parser
  attr_reader :verb, :path, :protocol, :host, :port, :origin, :accept, :content_length

  def initialize(request)
    @verb, @path, @protocol = request[0].split

    request.each do |line|
      key, value = line.split(': ')
      case key
      when 'Host'           then @host   = value
      when 'Accept'         then @accept = value
      when 'Content-Length' then @content_length = value.to_i
      end
    end

    @origin, @port = @host.split(':')
  end

  def find_word
    path.scan(/\=\w*/)[0].delete('=')
  end

  def find_guess(client)
    body    = client.read(content_length)
    guess   = body.scan(/\n\d\d?\r?/m)[0]
    guess ||= body.scan(/guess=.*/)[0]
    guess.delete!("guess=\n\r")
    guess.to_i
  end

end