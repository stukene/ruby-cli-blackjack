class Player < ActiveRecord::Base
    has_many :cards, through: :player_cards
    
end