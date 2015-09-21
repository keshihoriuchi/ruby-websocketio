require 'spec_helper'

describe WebsocketIO::Client do
  before do
    @server = TestServer.new
    @socket = TCPSocket.new('localhost', @server.port)
  end

  after do
    @socket.close
    @server.stop
  end

  let(:url) { "ws://localhost:#{@server.port}" }

  describe '#new' do
    subject { WebsocketIO::Client.new @socket, url: url }

    it 'connects a server' do
      subject
      expect(@server.connected).to be_truthy
    end
  end
end
