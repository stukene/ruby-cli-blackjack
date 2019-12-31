class CreateRoundCards < ActiveRecord::Migration[5.2]
  def change
    create_table :round_cards do |t|
      t.integer :round_id
      t.integer :card_id
    end
  end
end
