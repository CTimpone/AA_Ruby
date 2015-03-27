require_relative 'card'

class Deck


  def self.generate_standard
    deck = []
    Card.suits.each do |suit|
      Card.values.each do |val|
        deck << Card.new(suit, val)
      end
    end
    deck
  end

  def initialize(cards = Deck.generate_standard)
    @cards = cards
  end

  def count
    @cards.count
  end

  def take(num)
    if num > count
      raise StandardError.new "More than the number of cards remaining in the deck"
    end
    take_array = []
    num.times do
      take_array << @cards.shift
    end
    take_array
  end

  def shuffle
    @cards.shuffle!
  end

  private
  attr_reader :cards

end
