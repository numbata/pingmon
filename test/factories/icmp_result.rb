FactoryGirl.define do
  factory :icmp_result do
    host
    icmp_period
    seq { generate :integer }
    rtt { generate :integer }
  end
end
