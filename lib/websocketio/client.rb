# coding: utf-8

require 'websocket'
require 'filter_io'
require 'forwardable'

module WebSocketIO
  class Client
    extend Forwardable
    attr_reader :socket

    def_delegators :@filtered_socket, :read, :getc

    def initialize(socket, handshake_args, options = {})
      @socket  = socket
      @options = options

      @handshake = WebSocket::Handshake::Client.new(handshake_args)
      @socket.write @handshake.to_s
      until @handshake.finished? do
        @handshake << @socket.getc
      end

      # TODO: FilterIO assume that eof? isn't blocking method. But TCPSocket#eof? is.
      # See http://docs.ruby-lang.org/en/2.2.0/IO.html#method-i-eof-3F
      def @socket.eof?; closed?; end
      @filtered_socket = filter(@socket, @handshake.version)
    end

    def close
      send_frame type: :close
      @socket.close
      @socket = nil
      @closed = true
    end

    def closed?
      @closed
    end

    def write(str)
      send_frame data: str
      str.to_s.bytesize
    end

    private

    def send_frame(params)
      params = {
        data:    nil,
        type:    @options[:write_type] || :text,
        version: @handshake.version
      }.merge(params)
      frame = WebSocket::Frame::Outgoing::Client.new(params)
      @socket.write frame.to_s
    end

    def filter(socket, version)
      frame = WebSocket::Frame::Incoming::Client.new(version: version)
      pushed_size = 0
      FilterIO.new socket, block_size: 1 do |data|
        frame << data[pushed_size]
        pushed_size += 1
        buffered = frame.next
        raise FilterIO::NeedMoreData unless buffered
        pushed_size = 0
        buffered.to_s
      end
    end
  end
end
