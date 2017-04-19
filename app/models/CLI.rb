class CLI



def self.intro_image
	puts ' __  __            _           '.red
	puts '|  \/  |          | |          '.red
	puts '| \  / | ___  __ _| | _'.red + '✔'.green + '_  ___ '.red
	puts '| |\/| |/ _ \/ _  | |/ _ \/ _ \.'.red
	puts '| |  | |  __/ (_| | |  __/  __/'.red
	puts '|_|  |_|\___|\__,_|_|\___|\___|'.red

	puts "Welcome to Mealee!"
end


def self.enter_name
	puts "Please enter your " + "full name".blue + ":"
	@name = gets.chomp
	@name
end

def self.enter_term
	puts "What are you lookin' for?"
	@term = gets.chomp
	@term
end

end

