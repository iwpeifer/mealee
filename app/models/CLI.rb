class CLI



def self.intro_image
	puts ' __  __            _           '.red
	puts '|  \/  |          | |          '.red
	puts '| \  / | ___  __ _| | _'.red + '✔'.green + '_  ___ '.red
	puts '| |\/| |/ _ \/ _  | |/ _ \/ _ \.'.red
	puts '| |  | |  __/ (_| | |  __/  __/'.red
	puts '|_|  |_|\___|\__,_|_|\___|\___|'.red
	puts "\n"
end

def self.welcome
	puts "Welcome to Mealee!"
end


def self.enter_name
	puts "Please enter your " + "full name".blue + ":"
	@name = gets.chomp
	@name
end

def self.options(user)
	choice = 0
	until choice == "1"
	puts ""
	puts "Would you like to:\n1. Play Mealee\n2. View your top restaurants\n3. View the community's top restaurants\n\nType 'exit' to quit."
	choice = gets.chomp
	if choice == "2"
		puts ""
		user.best_rankings
	elsif choice == "3"
		Restaurant.top_ten
	elsif choice == "exit"
		puts ""
		puts "Thanks for playing!"
		exit
	end
end
end

def self.enter_term
	puts "What are you lookin' for?"
	@term = gets.chomp
	@term
end

end

