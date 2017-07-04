require_relative '../init'
require_relative './web_api_app'
require_relative './icmp_manager'

EM.run do
  dispatch = Rack::Builder.app do
    map '/' do
      run WebApiApp.new
    end
  end

  Rack::Server.start(
    app: dispatch,
    server: 'thin',
    Host: Config['master']['http']['host'],
    Port: Config['master']['http']['port'],
    signals: false
  )
  WebSocket::EventMachine::Server.start(Config['master']['websocket']) do |worker_connection|
    IcmpManager::Worker.new(worker_connection)
  end
end

Signal.trap('INT') { EventMachine.stop_event_loop }
