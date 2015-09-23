# WebSocketIO

[![Build Status](https://travis-ci.org/keshihoriuchi/ruby-websocketio.svg)](https://travis-ci.org/keshihoriuchi/ruby-websocketio)

WebSocketIO is a Ruby library. It aims to capacitate applications or libraries implemented with TCPSocket to communicate with WebSocket easily.

WebSocketIO::Client is a object which can communicate through WebSocket with same interface as TCPSocket.

Inspired by [websocket-stream](https://github.com/maxogden/websocket-stream) of Node.js

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'websocketio'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install websocketio

## Usage

```ruby
require 'websocketio'

tcpsocket = TCPSocket.new('localhost', 8080)
websocketio = WebSocketIO::Client.new(tcpsocket, url: 'ws://localhost:8080')
websocketio.write 'How are you?'

trap('INT') { websocketio.close }
while c = websocket.read(1) do
  STDOUT << c
end
```

### new(socket, handshake\_args, options = {}) -> WebSocketIO::Client
#### socket

It requires a connected socket object.
All sockets which have same interface as TCPSocket are available.
When you want to connect over proxy, you may use [ruby-proxifier](https://github.com/samuelkadolph/ruby-proxifier). See `example` directory.

#### handshake\_args

Parameters for WebSocket handshaking.
This arg is given to `WebSocket::Handshake::Client.new` which is defined at [websocket-ruby](https://github.com/imanel/websocket-ruby#client-handshake).

#### options[:write\_type]

Type (opcode) of WebSocket frame sent by this object.
[Keys in `FRAME\_TYPE` defined at websocket-ruby](https://github.com/imanel/websocket-ruby/blob/master/lib/websocket/frame/handler/handler03.rb#L9) are available.
Default is `:text`.

## Implemented

* WebSocketIO::Client
    * new
    * write
    * read
    * getc
    * close
