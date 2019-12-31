
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
        round = Round.create(num: 1)
        Player.delete_all
        while count < num
            puts "Enter player #{count +1} name:"
            name = gets.chomp
            Player.create(name: name, chips: chips, round_id: round.id)
            count += 1
        end

    end

    def deal_cards(r_num, deck)
        count = Player.all.count
        players = Player.all
        i = 0
        while i < count
            if(deck == [])
                deck = [*(1..52)]
            end
            pull = deck.sample
            deck.delete_at(pull-1)
            p_id = player[i].id
            PlayerCard.create(player_id: p_id, card_id: pull)
            binding.pry
            i +=1
        end
        if(Player.all != [])
            
            deal_cards(r_num, deck)
        end
        binding.pry
    end
end