require 'bundler/setup'
Bundler.require

require "json"
require "http"
require "optparse"
require "pry"
require "colorize"
require 'active_record'
require 'rake'
require 'sqlite3'
require 'yaml/store'
require "launchy"

ENV['DATABASE_URL'] ||= 'sqlite3:db/mealee_records.db'

Dir[File.join(File.dirname(__FILE__), "../app/models", "*.rb")].each {|f| require f}
Dir[File.join(File.dirname(__FILE__), "../lib/support", "*.rb")].each {|f| require f}

ActiveRecord::Base.establish_connection(ENV["DATABASE_URL"])


#DBRegistry[ENV["ACTIVE_RECORD_ENV"]].connect!


# if ENV["ACTIVE_RECORD_ENV"] == "test"
#   ActiveRecord::Migration.verbose = false
# end
