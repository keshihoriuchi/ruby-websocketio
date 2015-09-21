# coding: utf-8

require 'websocket'

module WebsocketIO
  class Client
    def initialize(socket, handshake_args)
      @socket = socket
      @handshake = WebSocket::Handshake::Client.new(handshake_args)
      @socket.write @handshake.to_s
      until @handshake.finished? do
        @handshake << @socket.getc
      end
    end

    def close

    end

    def closed?
    end

    def read(length = nil, outbuf = '')

    end

    def write(str)
      frame = WebSocket::Frame::Outgoing::Client.new(
        data:    str,
        type:    :text,
        version: @handshake.version
      )
      @socket.write frame.to_s
      str.to_s.bytesize
    end
  end
end
