require 'pry'
# A moderate refactoring of the blackjack program I wrote after watching  
#   solutions.

def single_deal(deck, cards, dealer = 0)
  card = deck.pop  
  if dealer == 0
    puts "You draw a #{card[0]} of #{card[1]}"
  else 
    puts "The dealer draws a #{card[0]} of #{card[1]}"
  end
  cards << card
end

def score(cards)
  total = 0
  vals = cards.map{ |e| e[0] }
  vals.each do |val|
    if val == "Ace"
      total += 11
    elsif val.to_i == 0 
      total += 10
    else
      total += val.to_i
    end
  end

  vals.select{ |e| e == "Ace" }.count.times do
      total -= 10 if total > 21
  end

  total
end

def blackjack_check(player_cards, player_score, dealer_cards, dealer_score, name)
  blackjack = false
  if player_score == 21
    blackjack = true
    read_cards(player_cards, player_score, dealer_cards, name)
    puts "Blackjack!"
    if dealer_score != 21
      puts "You win! Congrats!"
    else 
      deal_read_cards(dealer_cards, dealer_score)
      puts "But the dealer also has blackjack. You draw."
    end
  elsif dealer_score == 21
    blackjack = true
    read_cards(player_cards, player_score, dealer_cards, name)
    deal_read_cards(dealer_cards, dealer_score)
    puts "Sorry, the dealer has blackjack. You lose."
  end
  blackjack
end

def play_player_hand(deck, player_cards, player_score, dealer_cards, name)
  read_cards(player_cards, player_score, dealer_cards, name)
  while true  
    puts "What would you like to do, #{name}? Type 'stay' or 'hit':"
    input = gets.chomp
    if input == "stay"
      break
    elsif input == "hit"
      player_cards = single_deal(deck, player_cards, dealer = 0)
      player_score = score(player_cards)
      read_cards(player_cards, player_score, dealer_cards, name)
    else
      puts
      puts "Sorry, not a valid input."
      read_cards(player_cards, player_score, dealer_cards, name)
    end

    if player_score > 21
      puts "You busted! Sorry, #{name}, but you lose."
      break
    end
  end
  player_score
end

def read_cards(cards, score, deal_cards, name)
  puts "You have:"
  cards.each do |card|
    puts "#{card[0]} of #{card[1]}"
  end
  puts "Your score: #{score}"
  puts "Dealer showing: #{deal_cards[0][0]} of #{deal_cards[0][1]}"
end

def deal_read_cards(cards, score)
  puts "The dealer has:"
  cards.each do |card|
    puts "#{card[0]} of #{card[1]}"
  end
  puts "Dealer's score: #{score}"
end

def play_dealer_hand(deck, dealer_cards, dealer_score)
  while dealer_score < 17
    dealer_cards = single_deal(deck, dealer_cards, dealer = 1)
    dealer_score = score(dealer_cards)
    deal_read_cards(dealer_cards, dealer_score)
    sleep(1)
  end
  dealer_score
end

def resolve_game(player_score, dealer_score, name)
  if dealer_score > 21
    puts "The dealer busts! You win, #{name}."
  else
    puts "#{name}'s score: #{player_score}"
    if player_score > dealer_score
      puts "You win, #{name}."
    elsif player_score < dealer_score
      puts "You lose, #{name}."
    else
      puts "You draw, #{name}."
    end
  end
end

def play_again?
  play_again = false
  while true
    puts "Play again? Please enter 'yes' or 'no'."
    input = gets.chomp
    if input == "yes"
      play_again = true
      break 
    elsif input == "no"
      break
    else
      puts "Sorry, not a valid input."
    end
  end
  play_again
end


puts "Welcome to John Morgan's procedural blackjack game! Please enter name:"
name = gets.chomp

# Adjust number of decks used to prevent counting (bonus question)
deck_num = 5
# vals = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'Jack', 'Queen', 'King', 
#         'Ace']
vals = ['10', 'Ace']
suits = %w(Clubs Diamonds Hearts Spades)
deck = vals.product(suits)
(deck_num - 1).times do
  deck = deck + vals.product(suits)
end
deck.shuffle!

while true
  while true
    player_cards = [deck.pop]
    dealer_cards = [deck.pop]
    player_cards << deck.pop
    dealer_cards << deck.pop
    player_score = score(player_cards)
    dealer_score = score(dealer_cards)

    blackjack = blackjack_check(player_cards, player_score, dealer_cards, 
                                 dealer_score, name)
    if blackjack
      break
    end

    player_score = play_player_hand(deck, player_cards, player_score, 
                                    dealer_cards, name)

    if player_score <= 21
      deal_read_cards(dealer_cards, dealer_score)
      sleep(1)
      dealer_score = play_dealer_hand(deck, dealer_cards, dealer_score)

      resolve_game(player_score, dealer_score, name)
    end
    break
  end

  if not play_again?
    puts "Thanks for playing!"
    break
  end
end



