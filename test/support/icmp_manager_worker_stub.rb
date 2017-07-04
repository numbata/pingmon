module IcmpManager
  class WorkerStub
    attr_reader :hosts

    def initialize(_connection = nil)
      @hosts = []
    end

    def close!
      IcmpManager.delete_worker self
    end

    def watch(host)
      @hosts << host
    end

    def unwatch(host)
      @hosts.delete host
    end
  end
end
