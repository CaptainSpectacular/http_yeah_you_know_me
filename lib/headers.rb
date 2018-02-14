class Headers

  def self.headers(response, tag)
    paths = { ok:           '200 ok',
              not_found:    '404 Not Found',
              forbidden:    '403 Forbidden',
              moved:        '302 Moved Permanently',
              error:        '500 Internal Server Error'}
    return redirection(response) if tag == :moved

    ["http/1.1 #{paths[tag]}",
    "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
    "server: ruby",
    "content-type: text/html; charset=iso-8859-1",
    "content-length: #{response.length}\r\n\r\n"].join("\r\n")
    
  end

  def self.redirection(response)
    ["http/1.1 302 Moved Permanently",
    "Location: http://localhost:9292/game",
    "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
    "server: ruby",
    "content-type: text/html; charset=iso-8859-1",
    "content-length: #{response.length}\r\n\r\n"].join("\r\n")
  end
end
