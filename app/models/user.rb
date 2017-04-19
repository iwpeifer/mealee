class User < ActiveRecord::Base
has_many :winners
has_many :losers
has_many :restaurants, through: :winners
has_many :restaurants, through: :losers

def best_rankings
    self.winners.collect {|w| w.restaurant}
end

def favorite

end

def worst_rankings
    binding.pry
end

def least_favorite

end



end

