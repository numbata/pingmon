$LOAD_PATH.push(File.join(__FILE__, '..'))
require_relative '../core/common.rb'
require 'web_api_app'
require 'icmp_manager'
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

  WebSocket::EventMachine::Server.start(host: ENV['WS_HOST'], port: ENV['MASTER_PORT']) do |worker_connection|
    IcmpManager::Worker.new(worker_connection)
  end
end

Signal.trap('INT') { EventMachine.stop_event_loop }
