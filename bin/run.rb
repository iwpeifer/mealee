require_relative '../config/environment.rb'
require_relative '../yelpmealee.rb'

puts "Welcome to Mealee!"
puts "Please enter your zip code:"
location = gets.chomp
puts "Please choose dinner or lunch:"
term = gets.chomp
#binding.pry

search(term, location)