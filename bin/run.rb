require_relative '../config/environment'

cli = CommandLineInterface.new
cli.greet
cli.player_setup

while Player.all.count > 0
    cli.bet
    cli.deal_cards
    cli.play_game
    cli.dealer_hit
    cli.end_game
end

puts "<---------GAME OVER!--------->\n\n\n".colorize(:red)

