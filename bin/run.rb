require_relative '../config/environment.rb'
require_relative '../lib/yelpmealee.rb'


puts ' __  __            _           '.red
puts '|  \/  |          | |          '.red
puts '| \  / | ___  __ _| | _'.red + '✔'.green + '_  ___ '.red
puts '| |\/| |/ _ \/ _  | |/ _ \/ _ \.'.red
puts '| |  | |  __/ (_| | |  __/  __/'.red
puts '|_|  |_|\___|\__,_|_|\___|\___|'.red

puts "Welcome to Mealee!"
puts "Please enter your " + "zip code".blue + ":"
#binding.pry
location = gets.chomp
puts " "
puts "What are you lookin' for?"
term = gets.chomp

new_game = Mealee.new
new_game.search(term, location)