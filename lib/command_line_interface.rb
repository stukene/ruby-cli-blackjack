
require 'pry'
class CommandLineInterface 
    def greet
        puts "Welcome to Texas Hold'em Poker!"

    end
 

    def player_setup
        puts "How many chips will each player start with?"
        chips = gets.chomp.to_i
        puts "How many people will be playing today?"
        num = gets.chomp.to_i
        count = 0
        Round.delete_all
        round = Round.create(name: "first")
        Player.delete_all
        while count < num
            puts "Enter player #{count +1} name:"
            name = gets.chomp
            Player.create(name: name, chips: chips, round_id: round.id)
            count += 1
        end

    end

    def deal_cards
        deck = Card.all
        binding.pry
    end
end