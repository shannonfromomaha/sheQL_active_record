require 'active_record'
require 'pg' # postgresql
require 'yaml'

db_config = YAML::load(File.open('./config/database.yml'))
ActiveRecord::Base.establish_connection(db_config)

class User < ActiveRecord::Base
end