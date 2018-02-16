class Requestor
  
  def build(client)
    request = []

    while line = client.gets and !line.chomp.empty?
      request << line.chomp
    end

    request
  end
end
