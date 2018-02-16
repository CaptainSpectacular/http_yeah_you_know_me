class Headers

  def self.headers(response, tag)
    paths = { ok:           '200 ok',
              not_found:    '404 Not Found',
              moved:        '302 Moved Permanently',
              forbidden:    '403 Forbidden',
              error:        '500 Internal Server Error'}

    ["http/1.1 #{paths[tag]}",
     "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
     "server: ruby",
     "content-type: text/html; charset=iso-8859-1",
     "content-length: #{response.length}\r\n\r\n"].join("\r\n")
  end
end
