class CreateDealerCards < ActiveRecord::Migration[5.2]
  def change
    create_table :dealer_cards do |t|
      t.integer :dealer_id
      t.integer :card_id
    end
  end
end
