require_relative '../init'
require_relative './icmp_worker'

@icmp_workers = {}

EM.run do
  config = {
    host: Config['worker']['master_host'],
    port: Config['worker']['master_port']
  }
  ws = WebSocket::EventMachine::Client.connect(config)

  ws.onmessage do |data, _|
    params = Oj.load(data)
    action = params['action']
    host = params['host']

    case action
    when 'watch'
      @icmp_workers[host] = IcmpWorker.new(host)
    when 'unwatch'
      worker = @icmp_workers[host]
      worker.stop
      @icmp_workers.delete host
    end
  end
end
