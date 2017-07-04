Sequel.migration do
  up do
    create_table :icmp_results do
      primary_key :id
      foreign_key :host_id, :hosts
      foreign_key :icmp_period_id, :icmp_periods
      column      :seq, :integer, null: false
      column      :rtt, :integer
      column      :status, :varchar, null: false
      column      :created_at, "timestamp", null: false
      column      :updated_at, "timestamp"
    end
  end

  down do
    drop_table :icmp_results
  end
end
