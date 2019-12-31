require_relative '../config/environment'

cli = CommandLineInterface.new
cli.greet
cli.player_setup
cli.deal_cards

