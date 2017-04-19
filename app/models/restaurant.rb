class Restaurant < ActiveRecord::Base
has_many :losers
has_many :winners
has_many :users, through: :winners
has_many :users, through: :losers

def wins
    self.winners.count
end

def losses
    self.losers.count
end

def self.most_wins
    puts self.all.sort_by {|r| r.winners.count}.collect {|res| "#{res.name} #{res.winners.count}"}.reverse.take(10)
end

def self.most_losses
    puts self.all.sort_by {|r| r.losers.count}.collect {|res| "#{res.name} #{res.losers.count}"}.reverse.take(10)
end

def ratio
    return "#{(self.wins.to_f/(self.losses.to_f+self.wins.to_f)*100).to_i}%" if losses != 0
    '100%'
end

def self.best
    puts self.sort_top.take(1)
end

def self.top_ten 
    puts self.sort_top.take(10)
end

def self.worst
    puts self.sort_bottom.take(1)
end

def self.bottom_ten
    puts self.sort_bottom.take(10)
end

def self.sort_top
    self.all.sort_by {|res| res.ratio.to_i}.reverse.each_with_index.collect {|rest, i| "#{i+1}. #{rest.name}: #{rest.ratio}"}
end

def self.sort_bottom
    self.all.sort_by {|res| res.ratio.to_i}.each_with_index.collect {|rest, i| "#{i+1}. #{rest.name}: #{rest.ratio}"}
end


end