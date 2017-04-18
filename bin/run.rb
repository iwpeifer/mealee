require_relative '../config/environment.rb'
require_relative '../yelpmealee.rb'


puts "Welcome to Mealee!"
puts "Please enter your zip code:"
location = gets.chomp
puts " "
puts "Please enter search terms:"
term = gets.chomp

new_game = Mealee.new
new_game.search(term, location)