require 'bundler/setup'
Bundler.require

require "json"
require "http"
require "optparse"
require "pry"
require "colorize"
require 'active_record'
require 'rake'
require 'pg'
require 'yaml/store'
require "launchy"

DBNAME = "mealee_records"
connection_details = YAML::load(File.open('config/database.yml'))
DB = ActiveRecord::Base.establish_connection(connection_details)

Dir[File.join(File.dirname(__FILE__), "../app/models", "*.rb")].each {|f| require f}
Dir[File.join(File.dirname(__FILE__), "../lib/support", "*.rb")].each {|f| require f}



#DBRegistry[ENV["ACTIVE_RECORD_ENV"]].connect!


if ENV["ACTIVE_RECORD_ENV"] == "test"
  ActiveRecord::Migration.verbose = false
end
