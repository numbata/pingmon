require 'config'
require 'pg/em'
require 'pg/em/connection_pool'

module Database
  def self.connection
    Sequel.extension :inflector

    db = Sequel.connect(config)
    db.extension :pg_inet

    db
  end

  def self.config
    Config[:database]
  end
end

Database.connection
