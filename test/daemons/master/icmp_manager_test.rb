require 'test_helper'
require 'icmp_manager'

describe IcmpManager do
  before(:each) do
    IcmpManager.send(:clear!)
  end

  it 'should serve host for watching without worker' do
    host = generate :ip_address
    IcmpManager.watch(host)

    assert { IcmpManager.watched?(host) }
  end

  it 'should remove host from watching' do
    host = generate :ip_address
    IcmpManager.watch(host)
    IcmpManager.unwatch(host)

    assert { IcmpManager.watched?(host) }
  end

  it 'should give host to worker' do
    host = generate :ip_address
    worker = IcmpManager::WorkerStub.new
    IcmpManager.add_worker(worker)

    IcmpManager.watch(host)

    assert { worker.hosts.include? host }
  end

  it 'should distribute evenly hosts between workers' do
    workers = Array.new(2) {
      worker = IcmpManager::WorkerStub.new
      IcmpManager.add_worker(worker)
      worker
    }

    hosts = Array.new(workers.count * 5) { generate :ip_address }

    hosts.each { |host| IcmpManager.watch(host) }

    assert { workers.map(&:hosts).map(&:count).uniq.count == 1 }
  end

  it 'shouldn\'t lost host on worker disconnect' do
    good_worker = IcmpManager::WorkerStub.new
    IcmpManager.add_worker(good_worker)
    bad_worker = IcmpManager::WorkerStub.new
    IcmpManager.add_worker(bad_worker)

    hosts = Array.new(10) { generate :ip_address }
    hosts.each { |host| IcmpManager.watch(host) }

    IcmpManager.delete_worker(bad_worker)

    assert { good_worker.hosts.sort == hosts.sort }
  end
end
