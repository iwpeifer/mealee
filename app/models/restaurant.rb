class Restaurant < ActiveRecord::Base
has_many :losers
has_many :winners
has_many :users, through: :winners
has_many :users, through: :losers

end