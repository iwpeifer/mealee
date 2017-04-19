class User < ActiveRecord::Base
has_many :winners
has_many :losers
has_many :restaurants, through: :winners
has_many :restaurants, through: :losers

def best_rankings
    binding.pry
end

def worst_rankings
    binding.pry
end



end

