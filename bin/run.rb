require_relative '../config/environment.rb'
require_relative '../yelpmealee.rb'

puts "Welcome to Mealee!"
puts "Please enter your " + "zip code".blue + ":"
location = gets.chomp
puts "What are you lookin' for?"
term = gets.chomp
#binding.pry

new_game = Mealee.new
new_game.search(term, location)

#Test