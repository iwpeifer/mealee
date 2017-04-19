class Loser < ActiveRecord::Base
belongs_to :user
belongs_to :restaurant


def self.losses_by_user(user)
    self.all.select {|r| r.user_id == user.id}.collect {|r| "#{r.restaurant.name}"}.sort.uniq
end

def self.users_by_restaurant(restaurant)
    self.all.select {|r| r.restaurant_id == restaurant.id}.collect {|r| r.user.name}.sort.uniq
end

def self.loss_count(restaurant)
    self.all.select {|r| r.restaurant_id == restaurant.id}.count
end

def self.all_restaurant_names
    self.all.collect {|r| r.restaurant.name}.sort.uniq
end

end
