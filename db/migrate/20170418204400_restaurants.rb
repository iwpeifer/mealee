class Restaurants < ActiveRecord::Migration[5.0]
  def change
    create_table :restaurants do |t|
      t.string :name
      t.float :rating
      t.integer :review_count
      t.string :category
      t.string :price
      t.string :location
      t.string :url
      t.timestamps
    end
  end
end
