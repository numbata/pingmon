FactoryGirl.define do
  factory :host do
    host { generate :ip_address }
  end
end
