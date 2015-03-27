require 'deck'
require 'card'


describe 'Deck' do

  describe '::generate_standard' do

    deck = Deck.generate_standard
    values = deck.map { |card| card.to_s}


    it 'fills with 52 cards' do
      expect(deck.count).to eq(52)
    end


    it 'every card value/suit combo is unique' do
      expect(values.uniq.count).to eq(52)
    end

  end

  describe '#initialize' do
    let(:sample_deck) do
      cards = [
        Card.new(:hearts, :three),
        Card.new(:spades, :ace),
        Card.new(:clubs, :ten)
      ]
    end

    it 'fills with 52 cards if passed no arguments' do
      deck = Deck.new
      expect(deck.count).to eq(52)
    end

    it 'can be given a different deck' do
      deck = Deck.new(sample_deck)
      expect(deck.count).to eq(3)
    end
  end

  it "does not expose its cards directly" do
    expect(Deck.new).not_to respond_to(:cards)
  end

  describe '#take' do

    let(:sample_deck) do
      cards = [
        Card.new(:hearts, :three),
        Card.new(:spades, :ace),
        Card.new(:clubs, :ten)
      ]
    end
    let(:deck) {Deck.new(sample_deck)}

    it 'return cards from the top of the deck' do
      expect(deck.take(2)).to eq([Card.new(:hearts, :three), Card.new(:spades, :ace)])
    end

    it 'decreases the count of the deck by number of cards taken' do
      deck.take(2)
      expect(deck.count).to eq(1)
    end

    it 'cannot take more than the number of cards remaining' do
      expect do
        deck.take(4)
      end.to raise_error("More than the number of cards remaining in the deck")
    end
  end

  describe '#shuffle' do

    it 'calls the shuffle method' do
      deck = Deck.new
      expect(deck.shuffle).to receive(:shuffle!)
      deck.shuffle
    end

  end

end
