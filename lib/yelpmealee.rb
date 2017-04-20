class Mealee

  CLIENT_ID = 'ZCnzIJoSgo8zjWL8uz68fw'
  CLIENT_SECRET = 'HFe3UgFsaDsL1isRH4Hu87RlYlGOOkTXApkkdLmtlogR9Qt4dsqWYo5PTyeJBtWn'

  API_HOST = "https://api.yelp.com"
  SEARCH_PATH = "/v3/businesses/search"
  BUSINESS_PATH = "/v3/businesses/"  # trailing / because we append the business id to the path
  TOKEN_PATH = "/oauth2/token"
  GRANT_TYPE = "client_credentials"

  DEFAULT_BUSINESS_ID = "yelp-new-york-3"
  DEFAULT_TERM = "dinner"
  DEFAULT_LOCATION = "11 Broadway, New York, NY"
  SEARCH_LIMIT = 40

  attr_accessor :url, :options, :search_url, :search_params, :user, :results, :set_of_ten, :set_of_ten_dup, :winner, :challenger, :loser

	#connect to Yelp API then collect businesses for game
	
  def populate_options
  	self.results = HTTP.auth(self.bearer_token).get(search_url, params: search_params).parse
end

  def create_restaurants
      self.results["businesses"].each do |x| 
	      restaurant = {
					name: x["name"].underline,
					rating: "#{x["rating"]} based on #{x["review_count"]} reviews", 
					review_count: x["review_count"],
					location: x["location"]["display_address"].join(", ").to_s,
					category: x["categories"].collect {|y| y["title"]}.join(", ").to_s,
					distance: "#{(x["distance"]/100).round} minute walk",
					price: "#{x["price"]}",
					url: x["url"]
				}
	      self.options << restaurant
    	end

  end

  def choose_ten
		self.set_of_ten = self.options.sample(10)
		#binding.pry
		self.set_of_ten_dup = self.set_of_ten.dup
	end

	def take_out_losers
		self.options.reject!{|x| self.set_of_ten.include? x}
	end
	
	#main display method - acceptts ten business options and runs through match ups until user chooses or options run out
  def play

		if ran_out_of_options?
  			puts "SORRY, YOU ARE HOPELESSLY INDECISIVE".red.blink
  			exit
  	end

		#select first option in match up. -- FIRST LOOP ONLY
		winner = select_winner

	  until self.set_of_ten_dup.length == 1 do
				challenger = select_challenger(winner)
	      
	      system "clear"

			  display_choices(winner, challenger)
				input = input_prompt(winner, challenger)
	      
				match_arr = add_businesses(winner,challenger)

				add_to_winner_loser_tables(match_arr[0],match_arr[1]) if input == '1' || input == '1!'
				add_to_winner_loser_tables(match_arr[1],match_arr[0]) if input == '2' || input == '2!'
				winner = challenger if input == '2' || input == '2!'
				self.url = winner[:url]
				break if input == '1!' || input == '2!'
				
	      # self.url = winner[:url]

				remove_from_match_options(winner, challenger, input)
	  end
	  puts "We recommend you go to " + "#{winner[:name]}".green + "!" 
  end


	def add_businesses(winner, challenger)
		r1 = Restaurant.find_or_create_by(name: winner[:name].uncolorize, location: winner[:location], category: winner[:category], price: winner[:price])
	  r2 = Restaurant.find_or_create_by(name: challenger[:name].uncolorize, location: challenger[:location], category: challenger[:category], price: challenger[:price])
		[r1, r2]
	end

	def add_to_winner_loser_tables(winner,loser)
		Winner.create(user_id: self.user.id, restaurant_id: winner.id)
	  Loser.create(user_id: self.user.id, restaurant_id: loser.id)      
	end

	def choiceprompt
		puts "\nPlease choose option" + " 1 ".blue + "or" + " 2".red + ".\nType" + " '1!' ".blue + "or" + " '2!' ".red + "if you've found on a winner."
	  puts "Type" + " 'more' ".yellow + "to see Yelp pages. You can also type 'help' or 'exit'\n"
	end
	
	def goodbye
		puts "\nThanks for using Mealee!\n"
		exit
	end

	def help
		system "clear"
		puts "\n        Mealee is designed to help the indecisive among us and is built using the Yelp Fusion API.  Mealee pulls local business data and puts businesses side by side, allowing the user to narrow their choices until they find a business they would like to go to.  To use, enter your zip code or address, then enter what you are interested in searching for.  Search broadly for things like 'dinner' or 'museums,' or more specifically for type of cuisine or business type.\n"
		puts "Press 'Enter' to continue or type 'exit' to end the program."
		goodbye if gets.chomp == 'exit'
	end
	
	def select_winner
		
		winner = self.set_of_ten_dup.sample
	  self.url = winner[:url]
		winner
	end

	def select_challenger(winner)
		  challenger = self.set_of_ten_dup.sample
			until challenger != winner do
					challenger = self.set_of_ten_dup.sample
			end
			challenger
	end

	def input_prompt(winner, challenger)
		input = 0
		until input == "1" || input == "2" || input == "1!" || input == "2!" do
				choiceprompt
				input = gets.chomp.downcase
				if input == "exit" 
					goodbye
				elsif input == "help"
					help
					display_choices(winner, challenger)
				elsif input == "more"
					Launchy.open(winner[:url])
					Launchy.open(challenger[:url])
					system "clear"
					display_choices(winner, challenger)
				end
		end
		input
	end
	
	def remove_from_match_options(winner, challenger, input)
		self.set_of_ten_dup.reject! {|x| x == winner} if input == 2.to_s
		self.set_of_ten_dup.reject! {|x| x == challenger} if input == 1.to_s
		self.set_of_ten_dup
	end

  def ran_out_of_options?
  	self.options.length <= 1
  end
	
  def satisfied
    puts "Are you happy with your recommendation? (" + "Yes".green + " or " + "No".red + ")"
    choice = gets.chomp.downcase
    # binding.pry #####################
    if choice == "yes"
      Launchy.open(self.url)
      return 1
    else
      puts "Would you like another ten options? (" + "Yes".green + " or " + "No".red + ")"
      choice = gets.chomp.downcase
      if choice == "yes"
      return nil
    else 
      return 1
    end
  end
end

  def format(array)
    longest_key = array.keys.max_by(&:length)
    array.each {|key, value| printf "%-#{longest_key.length}s %s\n", key, value if key != :url && key != :review_count}
  end

  def display_choices(winner, challenger)
  	check1 = ""
  	check2 = ""
  	checkmark = check_wins(winner, challenger)
  	checkmark == 1 ? check1 = '✔'.yellow : check1 = ""
  	checkmark == 2 ? check2 = '✔'.yellow : check2 = ""
    puts "-------".blue + " 1 ".white.on_blue.blink + "------------------------ ".blue + check1
    format(winner)
    puts "-------".red + " 2 ".white.on_red.blink + "------------------------ ".red + check2
    format(challenger)
    puts "----------------------------------"
  end

	def initialize(term, location, user)
		@user = user
    @url = nil
    @options = []
    @search_url = "#{API_HOST}#{SEARCH_PATH}"
    @search_params = {term: term, location: location, limit: SEARCH_LIMIT}
  end
  
  def bearer_token
    url = "#{API_HOST}#{TOKEN_PATH}"

    raise "Please set your CLIENT_ID" if CLIENT_ID.nil?
    raise "Please set your CLIENT_SECRET" if CLIENT_SECRET.nil?

    params = {
      client_id: 'ZCnzIJoSgo8zjWL8uz68fw',
      client_secret: 'HFe3UgFsaDsL1isRH4Hu87RlYlGOOkTXApkkdLmtlogR9Qt4dsqWYo5PTyeJBtWn',
      grant_type: 'client_credentials'
    }

    response = HTTP.post(url, params: params)
    parsed = response.parse

    "#{parsed['token_type']} #{parsed['access_token']}"
  end

  def check_wins(winner, challenger)
  	#binding.pry
  	winner_wins = 0
  	challenger_wins = 0
  	checkmark = nil
  	if Restaurant.find_by(name: winner[:name].uncolorize)
  		winner_wins = Restaurant.find_by(name: winner[:name].uncolorize).wins
  	end
  	if Restaurant.find_by(name: challenger[:name].uncolorize)
  		challenger_wins = Restaurant.find_by(name: challenger[:name].uncolorize).wins
  	end
  	
  	if winner_wins > challenger_wins
  		checkmark = 1
  	elsif challenger_wins > winner_wins
  		checkmark = 2
  	else
  		checkmark = 0
  	end
  	checkmark
  end

end

