require_relative '../core/common.rb'
require_relative 'web_api_app.rb'
require 'eventmachine'

STDOUT.sync = true

EM.run do
  web_host = ENV['WEB_HOST'] || '0.0.0.0'
  web_port = ENV['WEB_PORT'] || '8080'

  dispatch = Rack::Builder.app do
    map '/' do
      run WebApiApp.new
    end
  end

  Rack::Server.start(
    app:    dispatch,
    server: 'thin',
    Host:   web_host,
    Port:   web_port,
    signals: false
  )

  WebSocket::EventMachine::Server.start(host: ENV['WS_HOST'], port: ENV['MASTER_PORT']) do |ws|
    ws.onopen do
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

Signal.trap('INT') { EventMachine.stop_event_loop }
