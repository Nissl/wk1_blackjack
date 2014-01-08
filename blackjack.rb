def single_deal(deck, cards, player = 1)
  card = deck.pop  
  if player == 1
    puts
    puts "You draw a #{card[0]} of #{card[1]}"
  else 
    puts
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
      total -= 10 if total > MAX_SCORE
  end

  total
end

def blackjack_check(player_cards, player_score, dealer_cards, dealer_score, name)
  blackjack = false
  if player_score == MAX_SCORE
    blackjack = true
    read_cards(player_cards, player_score, dealer_cards, name)
    puts "Blackjack!"
    if dealer_score != MAX_SCORE
      puts "You win! Congrats!"
    else 
      read_dealer_cards(dealer_cards, dealer_score)
      puts "But the dealer also has blackjack. You draw."
    end
  elsif dealer_score == MAX_SCORE
    blackjack = true
    read_cards(player_cards, player_score, dealer_cards, name)
    read_dealer_cards(dealer_cards, dealer_score)
    puts "Sorry, the dealer has blackjack. You lose."
  end
  blackjack
end

def play_player_hand(deck, player_cards, player_score, dealer_cards, name)
  read_cards(player_cards, player_score, dealer_cards, name)
  while true  
    puts
    puts "What would you like to do, #{name}? Type 'stay' or 'hit':"
    input = gets.chomp
    if input == "stay"
      break
    elsif input == "hit"
      player_cards = single_deal(deck, player_cards, player = 1)
      player_score = score(player_cards)
      read_cards(player_cards, player_score, dealer_cards, name)
    else
      puts
      puts "Sorry, not a valid input."
      read_cards(player_cards, player_score, dealer_cards, name)
    end

    if player_score > MAX_SCORE
      puts "You busted! Sorry, #{name}, but you lose."
      break
    end
  end
  player_score
end

def read_cards(cards, score, deal_cards, name)
  puts
  puts "You have:"
  cards.each do |card|
    puts "#{card[0]} of #{card[1]}"
  end
  puts
  puts "Your score: #{score}"
  puts "Dealer showing: #{deal_cards[0][0]} of #{deal_cards[0][1]}"
end

def read_dealer_cards(cards, score)
  puts
  puts "The dealer has:"
  cards.each do |card|
    puts "#{card[0]} of #{card[1]}"
  end
  puts "Dealer's score: #{score}"
end

def play_dealer_hand(deck, dealer_cards, dealer_score)
  while dealer_score < DEALER_CUTOFF
    dealer_cards = single_deal(deck, dealer_cards, player = 0)
    dealer_score = score(dealer_cards)
    read_dealer_cards(dealer_cards, dealer_score)
    sleep(1)
  end
  dealer_score
end

def resolve_game(player_score, dealer_score, name)
  if dealer_score > MAX_SCORE
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
    puts
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


MAX_SCORE = 21
DEALER_CUTOFF = 17

puts "Welcome to John Morgan's procedural blackjack game! Please enter name:"
name = gets.chomp
puts
puts "Welcome, #{name}!"

# Adjust number of decks used to prevent counting (bonus question).
deck_num = 5
vals = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'Jack', 'Queen', 'King', 
        'Ace']
suits = %w(Clubs Diamonds Hearts Spades)
deck = vals.product(suits)
(deck_num - 1).times do
  deck = deck + vals.product(suits)
end
deck.shuffle!

while true
  puts
  puts "The dealer deals the cards..."
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

    play_player_hand(deck, player_cards, player_score, 
                                    dealer_cards, name)
    player_score = score(player_cards)

    if player_score <= MAX_SCORE
      read_dealer_cards(dealer_cards, dealer_score)
      sleep(1)
      play_dealer_hand(deck, dealer_cards, dealer_score)
      dealer_score = score(dealer_cards)
      puts
      resolve_game(player_score, dealer_score, name)
    end
    break
  end

  if not play_again?
    puts
    puts "Thanks for playing!"
    puts
    break
  end
end



