class CreateDealers < ActiveRecord::Migration[5.2]
  def change
    create_table :dealers do |t|
      t.string :name
      t.integer :card_total
      t.integer :pot
    end
  end
end
