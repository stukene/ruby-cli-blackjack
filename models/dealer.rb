class Dealer < ActiveRecord::Base
    has_many :players
    has_many :dealer_cards
    has_many :cards, through: :dealer_cards
end