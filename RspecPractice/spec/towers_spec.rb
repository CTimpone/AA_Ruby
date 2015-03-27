require 'towers'
require 'rspec'

describe Towers do

  let(:hanoi) {Towers.new}

  describe '#board' do

    it "has a play board on creation of type array" do
      expect(hanoi.board.class).to eq(Array)
    end

    it "properly fills game board" do
      expect(hanoi.board).to eq([[3,2,1], nil, nil])
    end

  end

  let (:hanoiboard) {Towers.new( [[1], nil, [2]] )}

  describe '#move' do
    it 'calls valid_move?' do
      expect(hanoiboard).to receive(:valid_move?)
      hanoiboard.move([0,1])
    end

    it 'moves disc if valid_move? is true' do
      expect(hanoiboard.move([0,1])).to eq([nil, [1], [2]])
    end

    it 'does not move disc if valid_move? is false' do
      expect(hanoiboard.move([2,0])).to eq([[1], nil, [2]] )
    end
  end


  describe '#valid_move?' do
    it 'returns false if pulling from empty stack' do
      expect(hanoiboard.valid_move?([1,0])).to be false
    end
    it 'returns false if trying to place larger disc on smaller' do
      expect(hanoiboard.valid_move?([2,0])).to be false
    end
    it 'returns true if trying to palce disc on empty stack' do
      expect(hanoiboard.valid_move?([0,1])).to be true
    end
    it 'returns true if trying to place smaller disc on larger' do
      expect(hanoiboard.valid_move?([0,2])).to be true
    end
  end

  describe '#won?' do
    let(:tower1) { Towers.new([nil,[3,2,1],nil])}
    let(:tower2) { Towers.new([nil, nil, [3,2,1]])}
    it 'returns true if all in stack 1 in correct order' do
      expect(tower1.won?).to be true
    end

    it 'returns true if all in stack 2 in correct order' do
      expect(tower2.won?).to be true
    end

    it 'any elements in stack 1 should return false' do
      expect(hanoi.won?).to be false
    end
    it 'has elements in more than one stack' do
      tower3 = Towers.new([[2],[3],[1]])
      expect(tower3.won?).to be false
    end
  end


end
