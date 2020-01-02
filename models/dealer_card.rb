class DealerCard < ActiveRecord::Base
    belongs_to :dealer
    belongs_to :card
end