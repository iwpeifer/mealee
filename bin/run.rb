require_relative '../config/environment.rb'
require_relative '../yelpmealee.rb'


puts "Welcome to Mealee!"
puts "Please enter your " + "zip code".blue + ":"
binding.pry
location = gets.chomp
puts " "
puts "What are you lookin' for?"
term = gets.chomp

new_game = Mealee.new
new_game.search(term, location)