require 'player'
require 'card'

describe 'Player' do

  describe '#initialize' do

    it 'sets a bankroll' do
      player = Player.new(5000)
      expect(player.bankroll).to eq(5000)
    end

    it 'raises error if not given real money value' do
      expect do
        Player.new('hello')
      end.to raise_error("Not a valid amount.")
    end
  end

  describe '#discard' do

    it 'removes card from player\'s hand' do
      hand = double("hand")
      allow(hand).to receive(:discard).with([0,1]).and_return(2)
      player = Player.new(500)

      player.hand = hand
      expect(player.discard([0,1])).to eq(2)
    end
  end

end
