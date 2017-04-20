require_relative '../config/environment.rb'
require_relative '../lib/yelpmealee.rb'

CLI.intro_image
name = CLI.enter_name
u = User.find_or_create_by(name: name)
CLI.options(u)
user_location = u.user_location
user_term = CLI.enter_term
new_game = Mealee.new(user_term, user_location, u)

new_game.populate_options
#binding.pry
new_game.create_restaurants
#binding.pry

answer = nil
until !answer.nil?  
    new_game.choose_ten
    new_game.play
    new_game.take_out_losers
    answer = new_game.satisfied
end

new_game.goodbye


