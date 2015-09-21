# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'websocketio/version'

Gem::Specification.new do |spec|
  spec.name          = "websocketio"
  spec.version       = WebsocketIO::VERSION
  spec.authors       = ["Takeshi Horiuchi"]
  spec.email         = ["keshihoriuchi@gmail.com"]

  spec.summary       = 'Pseudo I/O on WebSocket.'
  spec.description   = 'Pseudo I/O on WebSocket.'
  spec.homepage      = "https://github.com/keshihoriuchi/websocketio"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "websocket-eventmachine-server"
  spec.add_development_dependency "proxifier"
  spec.add_dependency "websocket"
  spec.add_dependency "filter_io"
end
