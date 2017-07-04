Sequel.migration do
  up do
    execute_ddl <<-SQL
      CREATE SCHEMA IF NOT EXISTS #{Database.config["dbname"]}
    SQL
  end

  down do
    execute_ddl <<-SQL
      DROP SCHEMA IF EXISTS #{Database.config["dbname"]}
    SQL
  end
end
