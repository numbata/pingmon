require 'icmp4em'

class IcmpWorker
  def initialize(host)
    @icmp = ICMP4EM::ICMPv4.new(host)
    @host = Host.find_or_create(host: host)
    @period = IcmpPeriod.create(host: @host, started_at: Time.now)

    @icmp.on_success do |host, seq, rtt|
      # Avoid float values
      rtt_ns = rtt * 100_000
      IcmpResult.create(host_id: @host.id, icmp_period: @period, seq: seq, rtt: rtt_ns, status: :success)
    end

    @icmp.on_expire do |host, seq, exception|
      IcmpResult.create(host_id: @host.id, icmp_period: @period, seq: seq, status: :failure)
    end

    @icmp.schedule
  end

  def stop
    @period.update(finished_at: Time.now)
    @icmp.stop
  end
end
