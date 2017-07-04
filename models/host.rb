class Host < Sequel::Model
  plugin :validation_helpers
  plugin :timestamps, :create=>:created_at, :update=>:updated_at

  one_to_many :icmp_results
  one_to_many :icmp_periods

  def validate
    super
    octets = host.to_s.split('.').map(&:to_i)
    errors.add(:host, "IPv4 address should consist of four octets") unless octets.count == 4
    errors.add(:host, "Each part of IPv4 address should be int between 0 and 25)") unless octets.all? { |octet| octet.between?(0, 255) }
  end

  def as_json
    {
      id: id,
      host: host.to_s
    }
  end
end
