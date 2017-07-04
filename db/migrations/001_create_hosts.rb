Sequel.migration do
  up do
    create_table :hosts do
      primary_key :id
      column      :host, "inet", null: false
      column      :created_at, "timestamp", null: false
      column      :updated_at, "timestamp"
    end
  end

  down do
    drop_table :hosts
  end
end
