require 'database'

class Migrator
  Sequel.extension :migration

  MIGRATION_DIR = 'db/migrations'.freeze

  class << self
    def apply(db)
      Sequel::IntegerMigrator.new(db, MIGRATION_DIR).run
    end

    def rollback(db)
      Sequel::IntegerMigrator.new(db, MIGRATION_DIR, target: current_version(db) - 1).run
    end

    def current_version(db)
      Sequel::IntegerMigrator.new(db, MIGRATION_DIR).current
    end
  end
end
