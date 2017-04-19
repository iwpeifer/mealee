class Losers < ActiveRecord::Migration[5.0]
  def change
    create_table :losers do |t|
      t.integer :restaurant_id
      t.integer :user_id
      t.timestamps
    end
  end
end
