class Scorecards < ActiveRecord::Migration[5.0]
  def change
    create_table :scorecards do |t|
      t.integer :winner_id
      t.integer :loser_id
      t.integer :user_id
      t.timestamps
    end
    
  end
end
