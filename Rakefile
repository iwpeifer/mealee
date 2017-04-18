task :console => :environment do
  Pry.start
end

task :environment do
  ENV["PLAYLISTER_ENV"] ||= "development"
  require_relative 'config/environment'
  # require 'logger'
  # ActiveRecord::Base.logger = Logger.new(STDOUT)
end