require 'socket'               # Get sockets from stdlib
require 'net/http'

address = '172.16.5.228'
port = 8680

server = TCPServer.open(address, port)  # Socket to listen on port 2000
puts 'server is started, waiting for clients...'
loop {                         # Servers run forever
   client = server.accept       # Wait for a client to connect
   content = client.gets.chomp
   Net::HTTP.get('localhost', "/handle_event?content=#{content}", 4567) # => String
   client.close                 # Disconnect from the client
}
