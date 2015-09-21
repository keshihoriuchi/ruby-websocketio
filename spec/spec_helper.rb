require 'websocket-eventmachine-server'
require 'websocketio'

class TestServer
  attr_reader :port, :connected

  def initialize
    @port = 8080
    @connected = false

    @thread = Thread.new do
      begin
        EM.run do
          WebSocket::EventMachine::Server.start(:host => "0.0.0.0", :port => @port) do |ws|
            ws.onopen do
              @connected = true
              puts "Client connected"
            end

            ws.onmessage do |msg, type|
              puts "Received message: #{msg}"
              ws.send msg, :type => type
            end

            ws.onclose do
              puts "Client disconnected"
            end
          end
        end
      rescue => e
        p e
      end
    end

    sleep 0.5 # TODO: wait for EventMachine started
  end

  def stop
    EM.stop
  end
end
