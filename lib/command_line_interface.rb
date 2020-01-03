
require 'pry'
class CommandLineInterface 

    #greets player
    def greet
        puts "Welcome to Blackjack!"
    end
 
    #Input
    #*
    #*
    #Output
    #*
    #*Description
    #*Sets up the tables for the players and Dealer
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
            puts "Enter player #{count +1}'s name:"
            name = gets.chomp
            Player.create(name: name, chips: chips, dealer_id: dealer.id)
            count += 1
        end

    end

    #Input
    #*
    #*
    #Output
    #*
    #Desrition
    #*Gives cards to dealer and player(s)
    #*and creates the Join tables DealerCard and PlayerCard
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
        dealer = Dealer.first
        r_id = dealer.id
        DealerCard.create(dealer_id: r_id, card_id: card1)
        DealerCard.create(dealer_id: r_id, card_id: card2)
        rank1 = get_rank(Card.find_by(id: card1).rank)
        rank2 = get_rank(Card.find_by(id: card2).rank)
        dealer.card_total = rank1 + rank2
        dealer.save
        #deals all cards to players
        i = 0
        card_total = 0
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
            rank1 = get_rank(Card.find_by(id: card1).rank)
            rank2 = get_rank(Card.find_by(id: card2).rank)
            total = rank1 + rank2
            if(total > 21)
                total = 12
            end
            players[i].card_total = total
            players[i].save
            i +=1
        end
    end

    #Input
    #*
    #*
    #Output
    #*
    #Description
    #*Call bet_menu for each player
    #* and refactors if a player quits
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

    #Input
    #*
    #*
    #Output
    #*
    #Description
    #*Call game menu for each player
    def play_game
        i = 0
        count = Player.all.count
        players = Player.all
        while i < count
            game_menu(players[i])
            i += 1
        end
    end

    #Input
    #*
    #*
    #Output
    #*
    def game_menu(player)
        puts "It's #{player.name}'s turn!\n"
        puts "Press H to hit"
        puts "Press D to display cards"
        puts "Press E to end turn"
        input = gets.chomp

        if(input.downcase.eql? "h")
            if(player.card_total > 21)
               puts "You already busted you dummy!"
            elsif(player.card_total == 21)
                puts "You already won you dummy!"

            else 
                hit(player)
            end
            game_menu(player)
        elsif(input.downcase.eql? "d")
            display_palyer_cards(player)
            game_menu(player)
        elsif(input.downcase.eql? "e")

        else
            puts "Not a valid input"
            game_menu(player)
        end

    end


    #Input
    #*Player object as input
    #Output
    #*Prints dealer cards and Player cards
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
        if(rank == "10")
            bs = "\b"
        end 
        rank = rank.colorize(color)
        puts"\n<---------DEALER CARDS--------->".colorize(:blue)
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
        card_total = 0
        while i < count
            card = Card.find_by(id: cards[i].card_id)
            suit = card.suit
            color = get_color_of_card(suit)
            suit = suit.colorize(color)
            rank = card.rank
            bs = ""
            if(rank == "10")
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
 
        puts "Card Total = #{player.card_total}".colorize(:red)

    end

    def get_rank(rank)
        if(rank.to_i == 0)
            if(rank == "A")
                return 11
            end
            return 10
        end 
        return rank.to_i
        
    end

    #Input
    #*Car suit input
    #Output
    #*return color (black or red)
    def get_color_of_card(suit)
        if(suit == "♣" || suit == "♠")
            return :black

        elsif(suit == "♥" || suit == "♦")
            return :red
        end
    end

    #Input
    #* Payer object
    #*
    #Output
    #*
    #Description
    #*Menu that call functions to and takes user input
    def bet_menu(player)
        puts "It's #{player.name} turn!\n"
        puts "Press B to bet (only ends the turn in current state)"
        puts "Press N to change name"
        puts "Press Q to quit\n"
    
        input = gets.chomp
        #does nothing as of now
        if(input.downcase.eql? "b")

        elsif(input.downcase.eql? "q")
            Player.find(player.id).destroy
            return false
        elsif(input.downcase.eql? "n")
            puts "Enter new Name"
            name = gets.chomp
            player.name = name
            player.save
            bet_menu(player)


        else
            puts "Not a valid input"
            bet_menu(player)
        end
    end

    #Input
    #* A player from game menu
    #Output
    #* 
    #Description
    #*Takes in player grabs all cards in play to create deck
    #*Then calculates the total after the hit accounting for aces
    def hit(player)
 
        deck = get_deck
        card_id = deck.sample
        card = Card.find_by(id: card_id)
        PlayerCard.create(player_id: player.id, card_id: card_id)
        rank = get_rank(card.rank)
        if(rank == 11)
            if((player.card_total + rank) > 21)
                player.card_total += 1
            else
                player.card_total += rank
            end
        else 
            player.card_total += rank
        end
        if(player.card_total > 21)
            #past player cards to check for aces to make them
            #add only a one to the total
            p_cards = PlayerCard.where(player_id: player.id).pluck(:card_id)
            aces = p_cards.select{|id| id >= 49}
            non_aces = p_cards.select{|id| id < 49}
            # only does if there are aces 
            # otherwise total is final
            if(aces != [])
                non_ace_cards = Card.where(id: non_aces)
                n_count = non_ace_cards.count
                ace_count = aces.count
                i = 0
                sum = 0
                while i < n_count 
                  sum += get_rank(non_ace_cards[i].rank)
                  i += 1
                end
                j = 0
                # calculate adding the rest of the aces
                while j < ace_count
                    if(sum + 11 > 21 || (sum + (11 + ace_count - (j+1))) > 21)
                        sum += 1
                    else 
                        sum += 11
                    end
                    j+=1
                end
                player.card_total = sum
            end
        end
        player.save
    end

    #Helper function that gets the deck
    def get_deck
        p_card_ids = PlayerCard.pluck(:card_id)
        card_ids = Card.pluck(:id)
        d_card_ids = DealerCard.pluck(:card_id)
        deck = card_ids - p_card_ids
        deck = deck - d_card_ids
        return deck

    end

    # Input 
    # *
    # Output
    # *
    # Description
    # *Hits cards on dealer and handles aces
    # *simliar to hit for player
    def dealer_hit
        dealer = Dealer.first
        card_total = dealer.card_total
        if(card_total < 17 && check_card_total(card_total) == true)
            deck = get_deck
            card_id = deck.sample
            card = Card.find_by(id: card_id)
            DealerCard.create(dealer_id: dealer.id, card_id: card_id)
            rank = get_rank(card.rank)
            if(rank == 11)
                if((dealer.card_total + rank) > 21)
                    dealer.card_total += 1
                else
                    dealer.card_total += rank
                end
            else 
                dealer.card_total += rank
            end
            if(dealer.card_total > 21)
                #past dealer cards to check for aces to make them
                #add only a one to the total
                p_cards = DealerCard.where(dealer_id: dealer.id).pluck(:card_id)
                aces = p_cards.select{|id| id >= 49}
                non_aces = p_cards.select{|id| id < 49}
                # only does if there are aces 
                # otherwise total is final
                if(aces != [])
                    non_ace_cards = Card.where(id: non_aces)
                    n_count = non_ace_cards.count
                    ace_count = aces.count
                    i = 0
                    sum = 0
                    while i < n_count 
                      sum += get_rank(non_ace_cards[i].rank)
                      i += 1
                    end
                    j = 0
                    # calculate adding the rest of the aces
                    while j < ace_count
                        if(sum + 11 > 21 || (sum + (11 + ace_count - (j+1))) > 21)
                            sum += 1
                        else 
                            sum += 11
                        end
                        j+=1
                    end
                    dealer.card_total = sum
                end
            end
            dealer.save
        end
        if(dealer.card_total < 17)
            dealer_hit
        end

    end
    # Input 
    # *Dealer card total
    # Output
    # *Boolean
    # Description
    # *Checks dealer card total against all players 
    def check_card_total(dealer_total)
        player_card_total = Player.all.pluck(:card_total)
        i = 0
        count = player_card_total.count
        while(i < count)
            player_card_total[i]
            if(dealer_total < player_card_total[i])
                return true
            end
            i +=1
        end
        return false
    end

    def end_game 
        i = 0
        count = Player.all.count
        players = Player.all
        dealer = Dealer.first
        while i < count
            puts "#{players[i].name} your results are"
            p_total = players[i].card_total
            d_total = dealer.card_total
            puts "The Dealer got #{d_total}"
            puts "You got #{p_total}"
            #winner
            if(p_total > d_total && p_total < 22 || d_total > 21 || p_total == 21)
                puts "You won you winner!\n\n"
            elsif(p_total == d_total && p_total < 22)
                puts "It's a tie you keep your money!\n\n"
            #loser
            elsif(p_total <= d_total || p_total > 21)
                puts "You lost you loser!\n\n"
            end
  
            i += 1
        end
        sleep(2)
        puts"\n\n\n"
    end
end