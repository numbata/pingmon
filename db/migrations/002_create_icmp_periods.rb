Sequel.migration do
  up do
    create_table :icmp_periods do
      primary_key :id
      foreign_key :host_id, :hosts
      column      :started_at, "timestamp", null: false
      column      :finished_at, "timestamp"
      column      :created_at, "timestamp", null: false
      column      :updated_at, "timestamp"
    end
  end

  down do
    drop_table :icmp_periods
  end
end
