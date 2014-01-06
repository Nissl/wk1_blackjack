# This blackjack program has been coded without looking at any solutions.

# Adjust number of decks used to prevent counting (bonus question)
deck_num = 1
vals = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'jack', 'queen', 'king', 'ace']
suits = %w(clubs diamonds hearts spades)


def make_deck(vals, suits, deck_num)
  deck = []
  deck_num.times do
    vals.each do |val|
      suits.each do |suit|
        deck << [val, suit]
      end
    end
  end
  deck
end

def shuffle(deck)
  return recursive_shuffle(deck, [])
end

def recursive_shuffle(deck, shuffled_deck)
  if deck.length == 0
    return shuffled_deck
  else
    shuffled_deck.push(deck.slice!(rand(deck.length)))
    return recursive_shuffle(deck, shuffled_deck) 
  end
end

def deal_card(deck)
  card = deck.slice!(rand(deck.length))
end

def start_deal(deck)
  cards = []
  2.times do
    cards << deal_card(deck)
  end
  cards
end

def single_deal(deck, cards)
  card = deal_card(deck)  
  puts "You draw a #{card[0]} of #{card[1]}"
  cards << card
end

def dealer_deal(deck, cards)
  card = deal_card(deck)
  puts "The dealer draws a #{card[0]} of #{card[1]}"
  cards << card
end

def score(cards)
  score = 0

  cards.each do |card|
    case card[0]
    when '2' then score += 2
    when '3' then score += 3
    when '4' then score += 4
    when '5' then score += 5
    when '6' then score += 6
    when '7' then score += 7
    when '8' then score += 8
    when '9' then score += 9
    when '10' then score += 10
    when 'jack' then score += 10
    when 'queen' then score += 10
    when 'king' then score += 10
    end
  end

  cards.each do |card|
    if card[0] == "ace"
      score > 10 ? score += 1 : score += 11
    end
  end
  score
end

def play_player_hand(deck, player_cards, player_score, dealer_cards, name)
  read_cards(player_cards, player_score, dealer_cards, name)
  while true  
    puts "What would you like to do, #{name}? Type 'stay' or 'hit':"
    input = gets.chomp
    if input == "stay"
      break
    elsif input == "hit"
      player_cards = single_deal(deck, player_cards)
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
  puts "Dealer score: #{score}"
end

def play_dealer_hand(deck, dealer_cards, dealer_score)
  while dealer_score < 17
    dealer_cards = dealer_deal(deck, dealer_cards)
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
deck = shuffle(make_deck(vals, suits, deck_num))

while true
  player_cards = start_deal(deck)
  player_score = score(player_cards)
  dealer_cards = start_deal(deck)
  dealer_score = score(dealer_cards)

  if player_score == 21
    puts "Blackjack!"
  end

  player_score = play_player_hand(deck, player_cards, player_score, 
                                  dealer_cards, name)

  if player_score <= 21
    deal_read_cards(dealer_cards, dealer_score)
    sleep(1)
    dealer_score = play_dealer_hand(deck, dealer_cards, dealer_score)

    resolve_game(player_score, dealer_score, name)
  end

  if not play_again?
    puts "Thanks for playing!"
    break
  end
end



