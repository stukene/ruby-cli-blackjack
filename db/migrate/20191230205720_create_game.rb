class CreateGame < ActiveRecord::Migration[5.2]
  def change
    create_table :games do |t|
      t.string :flipped_cards
      t.integer :pot
      t.string :deck
    end
  end
end
