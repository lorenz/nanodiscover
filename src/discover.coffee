EventEmitter = require("eventemitter2").EventEmitter2
dgram = require "dgram"

port = 59544
interval = 100

class DiscoverAnnouncer
  constructor: (name,version) ->
    @identifier = [name,version].join "\0"
    @socket = dgram.createSocket "udp4"
    @socket.bind port + 1, =>
      @socket.setBroadcast true
      @socket.on "error", -> # Ignore errors
      setInterval =>
        message = new Buffer @identifier
        @socket.send message, 0, message.length, port, "255.255.255.255"
      , interval

class DiscoverBrowser extends EventEmitter
  constructor: (name,version) ->
    @nodes = []
    @nodesTimeouts = []
    @identifier = [name,version].join "\0"
    @timeout = (address) =>
        pos = @nodes.indexOf address
        @nodesTimeouts.splice pos, 1 unless pos is -1
        @nodes.splice pos, 1 unless pos is -1
        @emit "nodeDown", address
    @socket = dgram.createSocket "udp4"
    @socket.bind port
    @socket.on "message", (message,remote) =>
      if message.toString() is @identifier
        pos = @nodes.indexOf remote.address
        unless pos is -1
          clearTimeout @nodesTimeouts[pos]
          @nodesTimeouts[pos] = setTimeout @timeout, 2*interval, remote.address
        else
          @nodes.push remote.address
          @nodesTimeouts.push setTimeout @timeout, 2*interval, remote.address
          @emit "nodeUp", remote.address

module.exports =
  createBrowser: (name,version="latest") ->
    new DiscoverBrowser name, version
  createAnnouncer: (name,version="latest") ->
    new DiscoverAnnouncer name, version
