# coding: utf-8

require_relative '../spec/spec_helper'
require 'proxifier'
require 'uri'
require 'webrick'
require 'webrick/httpproxy'
require 'websocketio'

class TestProxy
  def initialize
    @s = WEBrick::HTTPProxyServer.new(BindAddress: '0.0.0.0', Port: 34567 )
    Thread.new { @s.start }
    sleep 1 # TODO: wait for WEBrick started
  end

  def stop
    @s.shutdown
  end
end

server = TestServer.new
proxy_server = TestProxy.new

proxifier = Proxifier::Proxy('http://localhost:34567')
socket = proxifier.open('localhost', server.port)
client = WebsocketIO::Client.new(socket, url: "ws://localhost:#{server.port}")
sleep 0.5

socket.close
proxy_server.stop
server.stop
