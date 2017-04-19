require_relative '../config/environment.rb'
require_relative '../lib/yelpmealee.rb'

CLI.intro_image
name = CLI.enter_name
u = User.find_or_create_by(name: name)
user_location = u.user_location
user_term = CLI.enter_term
new_game = Mealee.new(user_term, user_location)
new_game.search


# comment

