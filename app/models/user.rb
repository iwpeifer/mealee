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
    resukt = puts self.losers.group(:restaurant_id).count.map {|k,v| "#{v} #{Restaurant.find(k).name}"}.sort.reverse.take(10)
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

