class CreatePlayers < ActiveRecord::Migration[5.2]
  def change
    create_table :players do |t|
      t.string :name
      t.integer :chips
      t.integer :dealer_id
      t.integer :card_total
      t.integer :bet

    end
  end
end
