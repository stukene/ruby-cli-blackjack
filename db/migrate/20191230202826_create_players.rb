class CreatePlayers < ActiveRecord::Migration[5.2]
  def change
    create_table :players do |t|
      t.string :name
      t.integer :chips
      t.integer :card_id1
      t.integer :card_id2 
    end
  end
end
