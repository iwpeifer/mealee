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

  def search(term, location)
    url = "#{API_HOST}#{SEARCH_PATH}"
    params = {
      term: term,
      location: location,
      limit: SEARCH_LIMIT
    }

    response = HTTP.auth(self.bearer_token).get(url, params: params)
    rest = response.parse
    options = []
      
    rest["businesses"].each {|x| 

    restaurant = {}
    restaurant[:title] = x["name"]
    restaurant[:rating] = "#{x["rating"]} based on #{x["review_count"]} reviews" 
    restaurant[:location] = x["location"]["display_address"].join(", ").to_s
    restaurant[:categories] = x["categories"].collect {|y| y["title"]}.join(", ").to_s
    restaurant[:distance] = "#{(x["distance"]/100).round} minute walk"
    restaurant[:price] = "#{x["price"]}"


    options << restaurant
      }

    answer = 2
    until answer == 1

    options_set = options.sample(10)

    ten_options = options_set.dup

    # binding.pry

    self.choose_ten(ten_options)

    answer = self.satisfied

    options.reject!{|x| options_set.include? x}
      # binding.pry
    end
    puts "Thanks for using Mealee"
      # options_set = options.sample(10)
      # self.search(term, location)

  end

  def choose_ten(ten_options)

      winner = ten_options.sample
      until ten_options.length == 1 do
          challenger = ten_options.sample
          until challenger != winner do
              challenger = ten_options.sample
          end

          puts winner        
          puts challenger

          input = 0
          until input == "1" || input == "2" do
              puts "Please choose 1 or 2"
              input = gets.chomp
          end
          
          ten_options.reject! {|x| x == winner} if input == 2.to_s
          ten_options.reject! {|x| x == challenger} if input == 1.to_s

          winner = winner if input == 1.to_s
          winner = challenger if input == 2.to_s
      end
      puts "We recommend you go to #{winner}!"        
  end

  def satisfied
    puts "Are you happy with your recommendation? (Yes or No)"
    choice = gets.chomp
    # binding.pry
    if choice == "Yes"
      return 1
    else
      puts "Would you like another ten options? (Yes or No)"
      choice = gets.chomp
      if choice == "Yes"
      return 2
    else 
      return 1
    end
  end
end


end

