class User < ActiveRecord::Base
has_many :winners
has_many :losers
has_many :restaurants, through: :winners
has_many :restaurants, through: :losers

def ask_user_for_location
	puts "Use previous location? (" + "#{self.location}".blue + ") yes/no"
	answer = gets.chomp.downcase
		if answer == "yes" || answer == "" || answer == "y".downcase
			location = self.location
		elsif answer == "no".downcase || answer == "n".downcase
			location = input_location
			self.location = location
			self.save
		else
			puts "\n"
			ask_user_for_location
		end
	location
end

def input_location
	puts "Please enter location:"
	answer = gets.chomp.downcase
end


def user_location
 	if self.location == nil
		puts " "
		puts "Please enter your" +" location ".blue + "(address, zip code, city, etc)"
		location = gets.chomp
		self.location = location
		self.save
		else
			location = ask_user_for_location
		end
	location
end

def best_rankings
    result = self.winners.group(:restaurant_id).count.map {|k,v| "#{v} #{Restaurant.find(k).name}"}.sort.reverse.take(10)
 	result.each_with_index do |x, index|
 		count = x.split(' ')[0]
 		new_result = x.split(' ')[1..-1].join(' ')
 		puts "#{index+1}. #{new_result}, Wins: #{count}"
 		# binding.pry
 	end
end

def favorite
	result = self.winners.group(:restaurant_id).count.map {|k,v| "#{v} #{Restaurant.find(k).name}"}.sort.reverse.take(1)[0]
	count = result.split(' ')[0]
	new_result = result.split(' ')[1..-1].join(' ')
	puts "#{new_result}, Wins: #{count}"
end

def worst_rankings
    result = puts self.losers.group(:restaurant_id).count.map {|k,v| "#{v} #{Restaurant.find(k).name}"}.sort.reverse.take(10)
    result.each_with_index do |x, index|
 		count = x.split(' ')[0]
 		new_result = x.split(' ')[1..-1].join(' ')
 		puts "#{index+1}. #{new_result}, Losses: #{count}"
 	end
end

def least_favorite
	result =  self.losers.group(:restaurant_id).count.map {|k,v| "#{v} #{Restaurant.find(k).name}"}.sort.reverse.take(1)[0]
	count = result.split(' ')[0]
	new_result = result.split(' ')[1..-1].join(' ')
	puts "#{new_result}, Wins: #{count}"
end

end

