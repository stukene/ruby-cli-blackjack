class RoundCard < ActiveRecord::Base
    has_many :cards
    belongs_to :players
end