class Round < ActiveRecord::Base
    has_many :players
    has_many :round_cards
    has_many :cards, through: :round_cards
end