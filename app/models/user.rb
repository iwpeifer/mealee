class User < ActiveRecord::Base
has_many :winners
has_many :losers
has_many :restaurants, through: :winners
has_many :restaurants, through: :losers

def user_location
 	if self.location == nil
 		# initial_location(user)
 		# binding.pry
 	puts " "
	puts "Please enter your " + "zip code".blue + ":"
	location = gets.chomp
	self.location = location
	self.save
 	else
 		# existing_location(user)
 	puts "Use previous location? (Previous location = #{self.location}). If yes, press ENTER; if no, enter new location below."
	answer = gets.chomp
	if answer == ""
		location = self.location
	else
		location = answer
		self.location = location
		self.save
	end
	end
end

end

