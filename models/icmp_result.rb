class IcmpResult < Sequel::Model
  plugin :timestamps, :create=>:created_at, :update=>:updated_at

  many_to_one :host
  many_to_one :icmp_period

  dataset_module do
    def by_host(host)
      where(host: host)
    end

    def from(from)
      where{ created_at >= from }
    end

    def to(to)
      where{ created_at <= to }
    end

    def overall_statistics
      select(
        Sequel.lit('MIN(rtt)').as(:min),
        Sequel.lit('MAX(rtt)').as(:max),
        Sequel.lit('STDDEV(rtt)::float').as(:stddev),
        Sequel.lit('AVG(rtt)::float').as(:avg),
        Sequel.lit('COUNT(rtt)').as(:count),
        Sequel.lit('(percentile_cont(0.5) WITHIN GROUP (ORDER BY rtt))').as(:median),
        Sequel.lit("sum((status = 'failure')::int) * 100 / count(*)::float").as(:failure_percent)
      )
    end
  end
end
