require "active_record"
require 'yaml'

namespace :db do

  db_config       = YAML::load(File.open('./config/database.yml'))
  db_config_admin = db_config.merge({'database' => 'postgres', 'schema_search_path' => 'public'})
  
  desc "Set up the Cloud 9 environment"
  task :setupC9 do
    ActiveRecord::Base.establish_connection(db_config_admin)
    # template1 is what activerecord uses to make new databases
    # template0 and template1 in Cloud9 are SQL_ASCII instead of unicode
    # Make template1 not a template, drop it, and recreate it as unicode
    sql = []
    #  make template1 not a template anymore
    sql << "UPDATE pg_database SET datistemplate = FALSE WHERE datname = 'template1';"
    # drop template1
    sql << "DROP DATABASE template1;"
    # create template1 as a utf-8 encoded database
    sql << "CREATE DATABASE template1 WITH template = template0 encoding = 'UTF8';"
    # make template 1 a template
    sql << "UPDATE pg_database SET datistemplate = TRUE WHERE datname = 'template1';"
    sql.each do |s|
      ActiveRecord::Base.connection.execute(s)
    end
    puts "Cloud9 setup."
  end
  
  desc "Create the database"
  task :create do
    ActiveRecord::Base.establish_connection(db_config_admin)
    ActiveRecord::Base.connection.create_database(db_config["database"])
    puts "Database created."
  end

  desc "Migrate the database"
  task :migrate do
    ActiveRecord::Base.establish_connection(db_config)
    ActiveRecord::Migrator.migrate("db/migrate/")
    Rake::Task["db:schema"].invoke
    puts "Database migrated."
  end

  desc "Drop the database"
  task :drop do
    ActiveRecord::Base.establish_connection(db_config_admin)
    ActiveRecord::Base.connection.drop_database(db_config["database"])
    puts "Database deleted."
  end

  desc "Reset the database"
  task :reset => [:drop, :create, :migrate]

  desc 'Create a db/schema.rb file that is portable against any DB supported by AR'
  task :schema do
    ActiveRecord::Base.establish_connection(db_config)
    require 'active_record/schema_dumper'
    filename = "db/schema.rb"
    File.open(filename, "w:utf-8") do |file|
      ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, file)
    end
  end

end

namespace :g do
  desc "Generate migration"
  task :migration do
    name = ARGV[1] || raise("Specify name: rake g:migration your_migration")
    timestamp = Time.now.strftime("%Y%m%d%H%M%S")
    path = File.expand_path("../db/migrate/#{timestamp}_#{name}.rb", __FILE__)
    migration_class = name.split("_").map(&:capitalize).join

    File.open(path, 'w:utf-8') do |file|
      file.write <<-EOF
class #{migration_class} < ActiveRecord::Migration[5.0]
  def change
  end
end
      EOF
    end

    puts "Migration #{path} created"
    abort # needed stop other tasks
  end
end

task :default do 
  options = { 
              "rake db:setupC9": "Will set up cloud9 postgres for you.  Only do once.",
              "rake db:create": "Will create a database",
              "rake db:migrate": "Will run migrations", 
              "rake db:drop": "Will drop the database",
              "rake db:reset": "Will reset the database",
              "rake g:migration": "Will create a migration" 
            }
  options.each do |h, v|
    puts "#{h}: #{v}"
  end
end