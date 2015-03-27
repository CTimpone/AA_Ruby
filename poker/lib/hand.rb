require_relative 'card'

class Hand


  attr_accessor :cards

  def self.deal_from(deck)
    hand = Hand.new
    cards = deck.take(5)
    hand.cards = cards
    hand
  end

  def initialize
  end

  def beats?(hand)
    self.power > hand.power
  end

  def power
    if straight_flush?
      power = 10 ** 18 * card_values.last
    elsif four_of_kind?
      power = 10 ** 16 * card_values[2]
    elsif full_house?
      power = 10 ** 14 * card_values[2]
    elsif flush?
      power = 10 ** 12 * card_values[4] + 10 ** 10 * card_values[3] +
                10 ** 8 * card_values[2] + 10 ** 6 * card_values[1] +
                10 ** 4 * card_values[0]
    elsif straight?
      if card_values[3] == 5
        power = 10 ** 10 * 5
      else
        power = 10 ** 10 * card_values[4]
      end
    elsif three_of_kind?
      uniq_array = card_values.uniq
      uniq_array.delete(card_values[2])
      power = 10 ** 8 * card_values[2] + 10 ** 2 * uniq_array[1] + uniq_array[0]
    elsif two_pair?
      uniq_array = card_values.uniq
      singular = uniq_array.select do |val|
        card_values.count(val) == 1
      end
      uniq_array.delete(singular[0])
      power = 10 ** 6 * uniq_array[1] + 10 ** 4 * uniq_array[0] + singular[0]
    elsif pair?
      uniq_array = card_values.uniq
      pair = uniq_array.select do |val|
        card_values.count(val) == 2
      end
      uniq_array.delete(pair[0])
      power = 10 ** 4 * pair[0] + 10 ** 2 * uniq_array[2] +
              10 * uniq_array[1] + uniq_array[0]
    else
      power = 10 ** 3 * card_values[4] + 10 ** 2 * card_values[3] +
              10 * card_values[2] + card_values[1] + card_values[0]
    end
    power
  end

  def flush?
    return true if card_suits.uniq.count == 1
    false
  end

  def straight?
    if (card_values.last - card_values.first) == 4 && card_values.uniq.count == 5
      return true
    elsif card_values == [2, 3, 4, 5, 14]
      return true
    end

    false
  end

  def straight_flush?
    straight? && flush?
  end

  def full_house?
    checker = card_values[2]
    card_values.count(checker) == 3 && card_values.uniq.count == 2
  end

  def four_of_kind?
    checker = card_values[2]
    card_values.count(checker) == 4
  end

  def three_of_kind?
    checker = card_values[2]
    card_values.count(checker) == 3
  end

  def two_pair?
    card_values.uniq.count == 3
  end

  def pair?
    card_values.uniq.count == 4
  end

  def card_values

    card_val = @cards.map do |card|
      card.true_value
    end
    card_val.sort
  end

  def card_suits
    card_suits = @cards.map do |card|
      card.suit
    end
    card_suits
  end



  def discard(indices)
    len = indices.count
    if len > 3
      raise StandardError.new "Cannot discard more than 3 cards from your hand"
    end

    indices.sort.reverse.each do |i|
      self.cards.delete_at(i)
    end

    len
  end

end

#initialize pass it cards
#cards accessor
#Value of hand logic
#Hand v Hand comparer
#Discard
