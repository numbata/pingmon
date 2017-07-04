require 'erb'
require 'migrator'

namespace :db do
  desc "Apply new migrations"
  task :migrate do
    Migrator.apply(Database.connection)
  end

  desc "Rollback migration"
  task :rollback do
    Migrator.rollback(Database.connection)
  end

  desc "Migration status"
  task :version do
    puts Migrator.current_version(Database.connection)
  end
end
