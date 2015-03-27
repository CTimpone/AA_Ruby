require 'hand'
require 'card'

describe 'Hand' do



  describe '::deal_from(deck)' do
    it 'should be 5 cards' do

      deck_cards = [
        Card.new(:spades, :deuce),
        Card.new(:spades, :three),
        Card.new(:spades, :four),
        Card.new(:spades, :five),
        Card.new(:spades, :six)
      ]

      deck = double("deck")
      allow(deck).to receive(:take).with(5).and_return(deck_cards)

      hand = Hand.deal_from(deck)

      expect(hand.cards).to match_array(deck_cards)

    end
  end

  describe '#discard' do

    it 'removes given number of cards from hand' do
      deck_cards = [
        Card.new(:spades, :deuce),
        Card.new(:spades, :three),
        Card.new(:spades, :four),
        Card.new(:spades, :five),
        Card.new(:spades, :six)
      ]

      deck = double("deck")
      allow(deck).to receive(:take).with(5).and_return(deck_cards)
      hand = Hand.deal_from(deck)

      expect(hand.discard([1,3,4])).to eq(3)
    end

    it 'will remove the selected cards from hand' do
      deck_cards = [
        Card.new(:spades, :deuce),
        Card.new(:spades, :three),
        Card.new(:spades, :four),
        Card.new(:spades, :five),
        Card.new(:spades, :six)
      ]

      s2, s3, s4, s5, s6 = deck_cards
      deck = double("deck")
      allow(deck).to receive(:take).with(5).and_return(deck_cards)
      hand = Hand.deal_from(deck)

      hand.discard([1,3,4])
      expect(hand.cards).to match_array([s2, s4])
    end

    it 'will not allow more than 3 cards discarded' do
      deck_cards = [
        Card.new(:spades, :deuce),
        Card.new(:spades, :three),
        Card.new(:spades, :four),
        Card.new(:spades, :five),
        Card.new(:spades, :six)
      ]

      deck = double("deck")
      allow(deck).to receive(:take).with(5).and_return(deck_cards)
      hand = Hand.deal_from(deck)

      expect do
        hand.discard([1,2,3,4])
      end.to raise_error("Cannot discard more than 3 cards from your hand")
    end

  end

  describe '#value' do
  end

  describe '#card_values' do
    it 'returns array only of card values' do
      deck_cards = [
        Card.new(:spades, :deuce),
        Card.new(:spades, :three),
        Card.new(:spades, :four),
        Card.new(:spades, :five),
        Card.new(:spades, :six)
      ]

      deck = double("deck")
      allow(deck).to receive(:take).with(5).and_return(deck_cards)
      hand = Hand.deal_from(deck)

      expect(hand.card_values).to eq([2,3,4,5,6])
    end

  end

  describe '#card_suits' do
    it 'returns array only of card suits' do

      deck_cards = [
        Card.new(:spades, :deuce),
        Card.new(:spades, :three),
        Card.new(:spades, :four),
        Card.new(:spades, :five),
        Card.new(:spades, :six)
      ]

      deck = double("deck")
      allow(deck).to receive(:take).with(5).and_return(deck_cards)
      hand = Hand.deal_from(deck)

      expect(hand.card_suits).to eq([:spades, :spades, :spades, :spades, :spades])
    end
  end

  describe '#flush?' do
    it 'returns false if all suits do not match' do

      deck_cards = [
        Card.new(:spades, :deuce),
        Card.new(:clubs, :three),
        Card.new(:spades, :four),
        Card.new(:hearts, :five),
        Card.new(:spades, :six)
      ]

      deck = double("deck")
      allow(deck).to receive(:take).with(5).and_return(deck_cards)
      hand = Hand.deal_from(deck)

      expect(hand.flush?).to be false
    end
    it 'returns true if all suits match' do

      deck_cards = [
        Card.new(:spades, :deuce),
        Card.new(:spades, :three),
        Card.new(:spades, :four),
        Card.new(:spades, :five),
        Card.new(:spades, :six)
      ]

      deck = double("deck")
      allow(deck).to receive(:take).with(5).and_return(deck_cards)
      hand = Hand.deal_from(deck)

      expect(hand.flush?).to be true
    end
  end

  describe 'straight?' do
    it 'returns false if there is no straight' do

      deck_cards = [
        Card.new(:spades, :deuce),
        Card.new(:clubs, :three),
        Card.new(:spades, :four),
        Card.new(:hearts, :five),
        Card.new(:spades, :eight)
      ]

      deck = double("deck")
      allow(deck).to receive(:take).with(5).and_return(deck_cards)
      hand = Hand.deal_from(deck)

      expect(hand.straight?).to be false
    end

    it 'returns true if there is a straight starting at 2 or higher' do

      deck_cards = [
        Card.new(:spades, :deuce),
        Card.new(:spades, :three),
        Card.new(:spades, :four),
        Card.new(:spades, :five),
        Card.new(:spades, :six)
      ]

      deck = double("deck")
      allow(deck).to receive(:take).with(5).and_return(deck_cards)
      hand = Hand.deal_from(deck)

      expect(hand.straight?).to be true
    end

    it 'returns true if there is a straight starting at ace' do

      deck_cards = [
        Card.new(:spades, :ace),
        Card.new(:spades, :deuce),
        Card.new(:spades, :three),
        Card.new(:spades, :four),
        Card.new(:spades, :five),
      ]

      deck = double("deck")
      allow(deck).to receive(:take).with(5).and_return(deck_cards)
      hand = Hand.deal_from(deck)

      expect(hand.straight?).to be true
    end

  end

  describe '#straight_flush?' do
    it 'returns true if there is a straight flush' do
    deck_cards = [
      Card.new(:spades, :ace),
      Card.new(:spades, :deuce),
      Card.new(:spades, :three),
      Card.new(:spades, :four),
      Card.new(:spades, :five),
    ]

    deck = double("deck")
    allow(deck).to receive(:take).with(5).and_return(deck_cards)
    hand = Hand.deal_from(deck)

    expect(hand.straight_flush?).to be true
    end

    it 'returns false if there is no straight flush' do
    deck_cards = [
      Card.new(:spades, :ace),
      Card.new(:spades, :deuce),
      Card.new(:spades, :three),
      Card.new(:hearts, :four),
      Card.new(:spades, :five),
    ]

    deck = double("deck")
    allow(deck).to receive(:take).with(5).and_return(deck_cards)
    hand = Hand.deal_from(deck)

    expect(hand.straight_flush?).to be false
    end
  end

  describe '#full_house?' do
    it 'returns true if there is a full house' do
      deck_cards = [
        Card.new(:spades, :ace),
        Card.new(:spades, :ace),
        Card.new(:spades, :five),
        Card.new(:spades, :five),
        Card.new(:spades, :five),
      ]

      deck = double("deck")
      allow(deck).to receive(:take).with(5).and_return(deck_cards)
      hand = Hand.deal_from(deck)
      expect(hand.full_house?).to be true
    end

    it 'returns false if there is no full house' do
      deck_cards = [
        Card.new(:spades, :ace),
        Card.new(:spades, :deuce),
        Card.new(:spades, :three),
        Card.new(:spades, :four),
        Card.new(:spades, :five),
      ]

      deck = double("deck")
      allow(deck).to receive(:take).with(5).and_return(deck_cards)
      hand = Hand.deal_from(deck)

      expect(hand.full_house?).to be false
    end

  end

  describe '#four_of_kind?' do
    it 'returns true if there is a four of a kind' do
      deck_cards = [
        Card.new(:spades, :ace),
        Card.new(:clubs, :five),
        Card.new(:hearts, :five),
        Card.new(:diamonds, :five),
        Card.new(:spades, :five),
      ]

      deck = double("deck")
      allow(deck).to receive(:take).with(5).and_return(deck_cards)
      hand = Hand.deal_from(deck)

      expect(hand.four_of_kind?).to be true
    end

    it 'returns false if there is no four of a kind' do
      deck_cards = [
        Card.new(:spades, :ace),
        Card.new(:spades, :deuce),
        Card.new(:spades, :three),
        Card.new(:spades, :four),
        Card.new(:spades, :five),
      ]

      deck = double("deck")
      allow(deck).to receive(:take).with(5).and_return(deck_cards)
      hand = Hand.deal_from(deck)

      expect(hand.four_of_kind?).to be false
    end
  end

  describe '#three_of_kind?' do
    it 'returns true if there is a three of a kind' do
      deck_cards = [
        Card.new(:spades, :ace),
        Card.new(:clubs, :deuce),
        Card.new(:hearts, :five),
        Card.new(:diamonds, :five),
        Card.new(:spades, :five),
      ]

      deck = double("deck")
      allow(deck).to receive(:take).with(5).and_return(deck_cards)
      hand = Hand.deal_from(deck)

      expect(hand.three_of_kind?).to be true
    end

    it 'returns false if there is no three of a kind' do
      deck_cards = [
        Card.new(:spades, :ace),
        Card.new(:spades, :deuce),
        Card.new(:spades, :three),
        Card.new(:spades, :four),
        Card.new(:spades, :five),
      ]

      deck = double("deck")
      allow(deck).to receive(:take).with(5).and_return(deck_cards)
      hand = Hand.deal_from(deck)

      expect(hand.three_of_kind?).to be false
    end
  end

  describe '#two_pair?' do

    it 'returns true if there is a two pair' do
      deck_cards = [
        Card.new(:spades, :ace),
        Card.new(:clubs, :deuce),
        Card.new(:hearts, :deuce),
        Card.new(:diamonds, :five),
        Card.new(:spades, :five),
      ]

      deck = double("deck")
      allow(deck).to receive(:take).with(5).and_return(deck_cards)
      hand = Hand.deal_from(deck)

      expect(hand.two_pair?).to be true
    end

    it 'returns false if there is no two_pair' do
      deck_cards = [
        Card.new(:spades, :ace),
        Card.new(:spades, :deuce),
        Card.new(:spades, :three),
        Card.new(:spades, :four),
        Card.new(:spades, :five),
      ]

      deck = double("deck")
      allow(deck).to receive(:take).with(5).and_return(deck_cards)
      hand = Hand.deal_from(deck)

      expect(hand.two_pair?).to be false
    end
  end

  describe '#pair?' do

    it 'returns true if there is a pair' do
      deck_cards = [
        Card.new(:spades, :ace),
        Card.new(:clubs, :deuce),
        Card.new(:hearts, :three),
        Card.new(:diamonds, :five),
        Card.new(:spades, :five),
      ]

      deck = double("deck")
      allow(deck).to receive(:take).with(5).and_return(deck_cards)
      hand = Hand.deal_from(deck)

      expect(hand.pair?).to be true
    end

    it 'returns false if there is no pair' do
      deck_cards = [
        Card.new(:spades, :ace),
        Card.new(:spades, :deuce),
        Card.new(:spades, :three),
        Card.new(:spades, :four),
        Card.new(:spades, :five),
      ]

      deck = double("deck")
      allow(deck).to receive(:take).with(5).and_return(deck_cards)
      hand = Hand.deal_from(deck)

      expect(hand.pair?).to be false
    end
  end

  describe '#power' do
    it 'returns over 10**18 for straight flush' do
      deck_cards = [
        Card.new(:spades, :ace),
        Card.new(:spades, :deuce),
        Card.new(:spades, :three),
        Card.new(:spades, :four),
        Card.new(:spades, :five),
      ]

      deck = double("deck")
      allow(deck).to receive(:take).with(5).and_return(deck_cards)
      hand = Hand.deal_from(deck)

      expect(hand.power).to be > 10**18
    end

    it 'returns between 10**16 and 10**18 for four of a kind' do
      deck_cards = [
        Card.new(:spades, :ace),
        Card.new(:spades, :three),
        Card.new(:hearts, :three),
        Card.new(:diamonds, :three),
        Card.new(:clubs, :three),
      ]

      deck = double("deck")
      allow(deck).to receive(:take).with(5).and_return(deck_cards)
      hand = Hand.deal_from(deck)

      expect(10**16..10**18).to cover(hand.power)
    end

    it 'returns between 10**14 and 10**16 for full house' do
      deck_cards = [
        Card.new(:spades, :ace),
        Card.new(:hearts, :ace),
        Card.new(:hearts, :three),
        Card.new(:diamonds, :three),
        Card.new(:clubs, :three),
      ]

      deck = double("deck")
      allow(deck).to receive(:take).with(5).and_return(deck_cards)
      hand = Hand.deal_from(deck)

      expect(10**14..10**16).to cover(hand.power)
    end
    it 'returns between 10**12 and 10**14 for flush' do
      deck_cards = [
        Card.new(:spades, :ace),
        Card.new(:spades, :deuce),
        Card.new(:spades, :three),
        Card.new(:spades, :four),
        Card.new(:spades, :eight),
      ]

      deck = double("deck")
      allow(deck).to receive(:take).with(5).and_return(deck_cards)
      hand = Hand.deal_from(deck)

      expect(10**12..10**14).to cover(hand.power)
    end
    it 'returns between 10**10 and 10**12 for straight' do
      deck_cards = [
        Card.new(:spades, :ace),
        Card.new(:spades, :deuce),
        Card.new(:spades, :three),
        Card.new(:spades, :four),
        Card.new(:hearts, :five),
      ]

      deck = double("deck")
      allow(deck).to receive(:take).with(5).and_return(deck_cards)
      hand = Hand.deal_from(deck)

      expect(10**10..10**12).to cover(hand.power)
    end
    it 'returns between 10**8 and 10**10 for three of a kind' do
      deck_cards = [
        Card.new(:spades, :ace),
        Card.new(:hearts, :king),
        Card.new(:hearts, :three),
        Card.new(:diamonds, :three),
        Card.new(:clubs, :three),
      ]

      deck = double("deck")
      allow(deck).to receive(:take).with(5).and_return(deck_cards)
      hand = Hand.deal_from(deck)

      expect(10**8..10**10).to cover(hand.power)
    end
    it 'returns between 10**6 and 10**8 for two pair' do
      deck_cards = [
        Card.new(:spades, :ace),
        Card.new(:hearts, :king),
        Card.new(:hearts, :ace),
        Card.new(:diamonds, :three),
        Card.new(:clubs, :three),
      ]

      deck = double("deck")
      allow(deck).to receive(:take).with(5).and_return(deck_cards)
      hand = Hand.deal_from(deck)

      expect(10**6..10**8).to cover(hand.power)
    end

    it 'returns between 10**4 and 10**6 for pair' do
      deck_cards = [
        Card.new(:spades, :ace),
        Card.new(:hearts, :king),
        Card.new(:hearts, :nine),
        Card.new(:diamonds, :three),
        Card.new(:clubs, :three),
      ]

      deck = double("deck")
      allow(deck).to receive(:take).with(5).and_return(deck_cards)
      hand = Hand.deal_from(deck)

      expect(10**4..10**6).to cover(hand.power)
    end
  end

  describe '#beats?' do

    it 'finds if player1 beats player2 when each has the same pair (check high cards)' do
      deck_cards = [
        Card.new(:spades, :ace),
        Card.new(:clubs, :king),
        Card.new(:hearts, :nine),
        Card.new(:diamonds, :three),
        Card.new(:clubs, :three),
      ]

      deck = double("deck")
      allow(deck).to receive(:take).with(5).and_return(deck_cards)
      hand1 = Hand.deal_from(deck)

      deck_cards = [
        Card.new(:hearts, :ace),
        Card.new(:hearts, :king),
        Card.new(:hearts, :queen),
        Card.new(:hearts, :three),
        Card.new(:spades, :three),
      ]

      deck = double("deck")
      allow(deck).to receive(:take).with(5).and_return(deck_cards)
      hand2 = Hand.deal_from(deck)

      expect(hand1.beats?(hand2)).to be false
    end

    it 'finds if player2 beats player1 when each has the same pair (check high cards)' do
      deck_cards = [
        Card.new(:spades, :ace),
        Card.new(:clubs, :king),
        Card.new(:hearts, :nine),
        Card.new(:diamonds, :three),
        Card.new(:clubs, :three),
      ]

      deck = double("deck")
      allow(deck).to receive(:take).with(5).and_return(deck_cards)
      hand1 = Hand.deal_from(deck)

      deck_cards = [
        Card.new(:hearts, :ace),
        Card.new(:hearts, :king),
        Card.new(:hearts, :queen),
        Card.new(:hearts, :three),
        Card.new(:spades, :three),
      ]

      deck = double("deck")
      allow(deck).to receive(:take).with(5).and_return(deck_cards)
      hand2 = Hand.deal_from(deck)

      expect(hand2.beats?(hand1)).to be true
    end
  end
end
