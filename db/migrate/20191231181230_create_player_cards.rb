class CreatePlayerCards < ActiveRecord::Migration[5.2]
  def change
    def change
      create_table :round_cards do |t|
        t.integer :player_id
        t.integer :card_id
      end
    end
  end
end
