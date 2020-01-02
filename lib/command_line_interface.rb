
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
        Dealer.delete_all
        dealer = Dealer.create(name: "Dealer")
        Player.delete_all
        while count < num
            puts "Enter player #{count +1} name:"
            name = gets.chomp
            Player.create(name: name, chips: chips, dealer_id: dealer.id)
            count += 1
        end

    end

    def deal_cards
        #creates deck
        deck = [*(1..52)]
        #clears join tables
        PlayerCard.delete_all
        DealerCard.delete_all
        #total num players for looping
        count = Player.all.count
        players = Player.all
        #Deals two cards to dealer
        card1 = deck.sample
        deck.delete_at(card1-1)
        card2 = deck.sample
        deck.delete_at(card2-1)
        r_id = Dealer.first.id
        DealerCard.create(dealer_id: r_id, card_id: card1)
        DealerCard.create(dealer_id: r_id, card_id: card2)
        #deals all cards to players
        i = 0
        while i < count
            if(deck == [])
                deck = [*(1..52)]
            end
            card1 = deck.sample
            deck.delete_at(card1-1)
            card2 = deck.sample
            deck.delete_at(card2-1)
            p_id = players[i].id
            PlayerCard.create(player_id: p_id, card_id: card1)
            PlayerCard.create(player_id: p_id, card_id: card2)
            i +=1
        end
    end

    def bet
        i = 0
        count = Player.all.count
        players = Player.all
        while i < count
            if(bet_menu(players[i]) == false)
                players = Player.all
                count = Player.all.count
            else 
                i += 1
            end
        end
    end

    def play_game
        i = 0
        count = Player.all.count
        players = Player.all
        while i < count
            display_palyer_cards(players[i])
            i += 1
        end
    end

    def game_menu
        puts "It's #{player.name} turn!\n"
        puts "Press H to hit (ends turn as of now)"
        puts "Press D to display cards"
        input = gets.chomp

        if()
        end

    end



    def display_palyer_cards(player)
        #Display dealer card first
        dealer_card = Card.find_by(id: DealerCard.first.card_id)
        suit = dealer_card.suit
        color = get_color_of_card(suit)
        suit = suit.colorize(color)
        rank = dealer_card.rank
        dots1 = "* * * * * * *".colorize(:blue)
        dots2 = " * * * * * * ".colorize(:blue)
        bs = ""
        if(rank == 10)
            bs = "\b"
        end 
        rank = rank.colorize(color)
        puts"<---------DEALER CARDS--------->".colorize(:blue)
        puts" ┌-------------┐ ┌-------------┐".colorize(:background => :green)
        puts" |#{dots1}| |#{rank}            #{bs}|".colorize(:background => :green)
        puts" |#{dots1}| |#{suit}            |".colorize(:background => :green)
        puts" |#{dots2}| |   -------   |".colorize(:background => :green)
        puts" |#{dots1}| |  |       |  |".colorize(:background => :green)
        puts" |#{dots2}| |  |       |  |".colorize(:background => :green)
        puts" |#{dots1}| |  |       |  |".colorize(:background => :green)
        puts" |#{dots2}| |  |   #{suit}   |  │".colorize(:background => :green)
        puts" |#{dots1}| |  |       |  │".colorize(:background => :green)
        puts" |#{dots2}| |  |       |  │".colorize(:background => :green)
        puts" |#{dots1}| |  |       |  |".colorize(:background => :green)
        puts" |#{dots2}| |   -------   |".colorize(:background => :green)
        puts" |#{dots1}| |            #{suit}|".colorize(:background => :green)
        puts" |#{dots1}| |            #{bs}#{rank}|".colorize(:background => :green)
        puts" └-------------┘ └-------------┘".colorize(:background => :green)

        cards = PlayerCard.where(player_id: player.id)
        i = 0
        count = cards.count
        puts"\n<---------PLAYER CARDS--------->".colorize(:red)
        while i < count
            card = Card.find_by(id: cards[i].card_id)
            suit = card.suit
            color = get_color_of_card(suit)
            suit = suit.colorize(color)
            rank = card.rank
            bs = ""
            if(rank == 10)
                bs = "\b"
            end 
            rank = rank.colorize(color)
            puts"  ┌-------------┐ ".colorize(:background => :green)
            puts"  |#{rank}            #{bs}| ".colorize(:background => :green)
            puts"  |#{suit}            | ".colorize(:background => :green)
            puts"  |   -------   | ".colorize(:background => :green)
            puts"  |  |       |  | ".colorize(:background => :green)
            puts"  |  |       |  | ".colorize(:background => :green)
            puts"  |  |       |  | ".colorize(:background => :green)
            puts"  |  |   #{suit}   |  | ".colorize(:background => :green)
            puts"  |  |       |  | ".colorize(:background => :green)
            puts"  |  |       |  | ".colorize(:background => :green)
            puts"  |  |       |  | ".colorize(:background => :green)
            puts"  |   -------   | ".colorize(:background => :green)
            puts"  |            #{suit}| ".colorize(:background => :green)
            puts"  |            #{bs}#{rank}| ".colorize(:background => :green)
            puts"  └-------------┘ ".colorize(:background => :green)

            i += 1
        end

    end

    def get_color_of_card(suit)
        if(suit == "♣" || suit == "♠")
            return :black

        elsif(suit == "♥" || suit == "♦")
            return :red
        end
    end

    def bet_menu(player)
        puts "It's #{player.name} turn!\n"
        puts "Press  B to bet (passes turn in current state)"
        puts "Press Q to quit"
        puts "Press N to change name\n"
    
        input = gets.chomp
        if(input.downcase.eql? "b")

        elsif(input.downcase.eql? "q")
            Player.find(player.id).destroy
            return false
        elsif(input.downcase.eql? "n")
            puts "Enter new Name"
            name = gets.chomp

        else
            puts "No valid input"
            bet_menu(player)
        end
    end


end