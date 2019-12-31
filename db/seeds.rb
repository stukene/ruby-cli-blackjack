@ranks = [*(2..10), 'J', 'Q', 'K', 'A']
@suits = ['♣', '♥', '♠', '♦']

@ranks.each do |rank|
  @suits.each do |suit|
    Card.create(suit: suit, rank: rank)
  end
end