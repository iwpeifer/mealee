class Users < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :location
      t.float :min_rating
    end
    
  end
end
