class IcmpPeriod < Sequel::Model
  plugin :timestamps, :create=>:created_at, :update=>:updated_at

  many_to_one :host
  one_to_many :icmp_results
end
