


# Place holders for Yelp Fusion's OAuth 2.0 credentials. Grab them
# from https://www.yelp.com/developers/v3/manage_app
CLIENT_ID = 'ZCnzIJoSgo8zjWL8uz68fw'
CLIENT_SECRET = 'HFe3UgFsaDsL1isRH4Hu87RlYlGOOkTXApkkdLmtlogR9Qt4dsqWYo5PTyeJBtWn'


# Constants, do not change these
API_HOST = "https://api.yelp.com"
SEARCH_PATH = "/v3/businesses/search"
BUSINESS_PATH = "/v3/businesses/"  # trailing / because we append the business id to the path
TOKEN_PATH = "/oauth2/token"
GRANT_TYPE = "client_credentials"


DEFAULT_BUSINESS_ID = "yelp-new-york-3"
DEFAULT_TERM = "dinner"
DEFAULT_LOCATION = "11 Broadway, New York, NY"
SEARCH_LIMIT = 40


# Make a request to the Fusion API token endpoint to get the access token.
# 
# host - the API's host
# path - the oauth2 token path
#
# Examples
#
#   bearer_token
#   # => "Bearer some_fake_access_token"
#
# Returns your access token
def bearer_token
  # Put the url together
  url = "#{API_HOST}#{TOKEN_PATH}"

  raise "Please set your CLIENT_ID" if CLIENT_ID.nil?
  raise "Please set your CLIENT_SECRET" if CLIENT_SECRET.nil?

  # Build our params hash
  params = {
    client_id: 'ZCnzIJoSgo8zjWL8uz68fw',
    client_secret: 'HFe3UgFsaDsL1isRH4Hu87RlYlGOOkTXApkkdLmtlogR9Qt4dsqWYo5PTyeJBtWn',
    grant_type: 'client_credentials'
  }

  response = HTTP.post(url, params: params)
  #binding.pry
  parsed = response.parse

  "#{parsed['token_type']} #{parsed['access_token']}"
  #binding.pry
  #'Bearer Vj13HHAG_05aJd_T4tQ5dN4u2e7iiUW4aaQkJlUaZS65nh-nwMdvpWznwlcOb8B2w9v-afJMPV6XMaZrQF67XukVB_kcnjoP9_4VOGf_jXP2eCfPoailjyqLDyT1WHYx'
end


# Make a request to the Fusion search endpoint. Full documentation is online at:
# https://www.yelp.com/developers/documentation/v3/business_search
#
# term - search term used to find businesses
# location - what geographic location the search should happen
#
# Examples
#
#   search("burrito", "san francisco")
#   # => {
#          "total": 1000000,
#          "businesses": [
#            "name": "El Farolito"
#            ...
#          ]
#        }
#
#   search("sea food", "Seattle")
#   # => {
#          "total": 1432,
#          "businesses": [
#            "name": "Taylor Shellfish Farms"
#            ...
#          ]
#        }
#
# Returns a parsed json object of the request
def search(term, location)
  url = "#{API_HOST}#{SEARCH_PATH}"
  params = {
    term: term,
    location: location,
    limit: SEARCH_LIMIT
  }

  response = HTTP.auth(bearer_token).get(url, params: params)
  #binding.pry
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

  choose_ten(options.sample(10))

  binding.pry
end

def choose_ten(options)

    winner = options.sample
    until options.length == 1 do
        challenger = options.sample
        until challenger != winner do
            challenger = options.sample
        end

        puts winner        
        puts challenger

        input = 0
        until input == "1" || input == "2" do
            puts "Please choose 1 or 2"
            input = gets.chomp
        end
        
        options.reject! {|x| x == winner} if input == 2.to_s
        options.reject! {|x| x == challenger} if input == 1.to_s

        winner = winner if input == 1.to_s
        winner = challenger if input == 2.to_s
    end

    puts winner        
    binding.pry


end


# Look up a business by a given business id. Full documentation is online at:
# https://www.yelp.com/developers/documentation/v3/business
# 
# business_id - a string business id
#
# Examples
# 
#   business("yelp-san-francisco")
#   # => {
#          "name": "Yelp",
#          "id": "yelp-san-francisco"
#          ...
#        }
#
# Returns a parsed json object of the request
def business(business_id)
  url = "#{API_HOST}#{BUSINESS_PATH}#{business_id}"

  response = HTTP.auth(bearer_token).get(url)
  response.parse
end


options = {}
OptionParser.new do |opts|
  opts.banner = "Example usage: ruby sample.rb (search|lookup) [options]"

  opts.on("-tTERM", "--term=TERM", "Search term (for search)") do |term|
    options[:term] = term
  end

  opts.on("-lLOCATION", "--location=LOCATION", "Search location (for search)") do |location|
    options[:location] = location
  end

  opts.on("-bBUSINESS_ID", "--business-id=BUSINESS_ID", "Business id (for lookup)") do |id|
    options[:business_id] = id
  end

  opts.on("-h", "--help", "Prints this help") do
    puts opts
    exit
  end
end.parse!

#change

command = ARGV


# case command.first
# when "search"
#   term = options.fetch(:term, DEFAULT_TERM)
#   location = options.fetch(:location, DEFAULT_LOCATION)

#   raise "business_id is not a valid parameter for searching" if options.key?(:business_id)

#   response = search(term, location)

#   puts "Found #{response["total"]} businesses. Listing #{SEARCH_LIMIT}:"
#   response["businesses"].each {|biz| puts biz["name"]}
# when "lookup"
#   business_id = options.fetch(:id, DEFAULT_BUSINESS_ID)


#   raise "term is not a valid parameter for lookup" if options.key?(:term)
#   raise "location is not a valid parameter for lookup" if options.key?(:lookup)

#   response = business(business_id)

#   puts "Found business with id #{business_id}:"
#   puts JSON.pretty_generate(response)
# else

#     search(DEFAULT_TERM, DEFAULT_LOCATION)
 
# end

#search(DEFAULT_TERM, DEFAULT_LOCATION)