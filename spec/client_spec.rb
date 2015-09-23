# coding: utf-8

require 'spec_helper'

describe WebSocketIO::Client do
  before do
    @server = TestServer.new(&builder)
    @socket = TCPSocket.new('localhost', @server.port)
  end

  after do
    @socket.close if close_on_after
    @server.stop
  end

  let(:url) { "ws://localhost:#{@server.port}" }
  let(:client) { WebSocketIO::Client.new @socket, url: url }
  let(:close_on_after) { true }

  describe '#new' do
    let(:builder) do
      Proc.new {|ws| ws.onopen { @connected = true } }
    end
    subject { client }

    it 'connects a server' do
      subject
      expect(@connected).to be_truthy
    end

    context 'when given options[:write_type]' do
      let(:builder) do
        Proc.new {|ws| ws.onmessage {|msg, type| @type = type }}
      end
      let(:client) { WebSocketIO::Client.new @socket, { url: url }, { write_type: :binary } }
      subject { client.write('fuga') }

      it "sends message whose type is options[:write_type]" do
        subject
        sleep 0.5 # TODO: wait for message received
        expect(@type).to eq(:binary)
      end
    end
  end

  describe '#write' do
    let(:builder) do
      Proc.new {|ws| ws.onmessage {|msg, type| @message = msg }}
    end
    let(:str) {'fuga'}
    subject { client.write(str) }

    it "sends message to server" do
      subject
      sleep 0.5 # TODO: wait for message received
      expect(@message).to eq(str)
    end
    it { is_expected.to eq(str.bytesize) }
  end

  describe '#read' do
    context 'When receive 1 frame' do
      let(:builder) do
        Proc.new {|ws| ws.onopen { ws.send('fuga') } }
      end
      subject { client.read(4) }
      it { is_expected.to eq('fuga') }
    end

    context 'When receive 3 frames' do
      let(:builder) do
        Proc.new do |ws|
          ws.onopen do
            ws.send('foo')
            ws.send('bar')
            ws.send('baz')
          end
        end
      end
      subject { client.read(8) }
      it { is_expected.to eq('foobarba') }
    end
  end

  describe '#getc' do
    let(:builder) do
      Proc.new {|ws| ws.onopen { ws.send('fuga') } }
    end
    subject { client.getc }
    it { is_expected.to eq('f') }
  end

  describe '#close' do
    let(:builder) do
      Proc.new {|ws| ws.onclose { @disconnected = true } }
    end
    let(:close_on_after) { false }
    subject do
      @client = client
      @client.close
    end
    it "sends close to server" do
      subject
      sleep 0.5 # TODO: wait for message received
      expect(@disconnected).to be_truthy
    end
    it 'make #closed? to return true' do
      subject
      expect(@client.closed?).to be_truthy
    end
  end
end
