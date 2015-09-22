# coding: utf-8

require 'websocket-eventmachine-server'
require 'websocketio'

class TestServer
  attr_reader :port

  def initialize(&block)
    @port = 8080

    @thread = Thread.new do
      begin
        EM.run do
          WebSocket::EventMachine::Server.start(
            { host: "0.0.0.0", port: @port },
            &block
          )
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
