module IcmpManager
  @workers = {}
  @hosts = {}

  def self.watch(host)
    return if @hosts[host]

    @hosts[host] = nil

    return unless worker = suitable_worker

    worker.watch host
    @hosts[host] = worker
    @workers[worker] += 1
  end

  def self.unwatch(host)
    return unless @hosts[host]

    worker = @hosts[host]
    worker.unwatch host
    @hosts.delete host
    @workers[worker] -= 1
  end

  def self.watched?(host)
    @hosts.key? host
  end

  def self.redistribute_hosts
    workers = @workers.keys
    hosts_per_worker_count = @hosts.count.fdiv(workers.count).round
    hosts_slices = @hosts.keys.each_slice(hosts_per_worker_count).to_a

    hosts_per_worker = Hash[workers.zip(hosts_slices)]
    hosts_per_worker.each do |worker, hosts|
    end
  end

  def self.suitable_worker
    worker, _ = @workers.min_by{ |worker, hosts_count| hosts_count }
    worker
  end

  def self.add_worker(worker)
    @workers[worker] = 0
  end

  def self.delete_worker(worker)
    if @workers[worker]
      worker_hosts = @hosts.select { |host, job_worker| job_worker == worker }.keys
      @workers.delete worker
      worker_hosts.each do |host|
        worker = suitable_worker
        @hosts[host] = worker
        worker.watch host
      end
    end
  end

  private

  def self.clear!
    @workers = {}
    @hosts = {}
  end

  class Worker
    def initialize(connection)
      connection.onopen do
        IcmpManager.add_worker self
      end

      connection.onclose do
        IcmpManager.delete_worker self
      end

      @connection = connection
    end

    def watch(host)
      @connection.send({action: :watch, host: host}.to_json)
    end

    def unwatch(host)
      @connection.send({action: :unwatch, host: host}.to_json)
    end
  end
end
