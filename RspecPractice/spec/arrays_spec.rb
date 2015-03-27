require 'arrays.rb'
require 'rspec'

describe 'Array' do

  describe '#my_uniq' do
    let(:arr)  {[1, 2, 1, 3, 3]}

    it 'return empty array when given empty array' do
      arr = []
      expect(arr.my_uniq).to eq([])
    end

    it 'generate erray with unique elements' do
      expect(arr.my_uniq).to eq([1, 2, 3])
    end

    it 'does not call #uniq' do
      expect(arr).not_to receive(:uniq)
      arr.my_uniq
    end
  end

  describe '#two_sum' do
    it 'return empty array when given empty array' do
      arr = []
      expect(arr.two_sum).to eq([])
    end
    it 'return empty array when there are no two sums' do
      arr = [1,2,3]
      expect(arr.two_sum).to eq([])
    end
    it 'return one pair for simple situation' do
      arr = [1,2,-1]
      expect(arr.two_sum).to eq([[0,2]])
    end
    it 'return multiple pairs when there are multiple pairs of different numbers' do
      expect([-1, 0, 2, -2, 1].two_sum).to eq([[0, 4], [2, 3]])
    end
    it "return multiple pairs when there are multiple pairs of same number" do
      expect([-1,1,1,-1].two_sum).to eq([[0,1],[0,2],[1,3],[2,3]])
    end
  end

  describe '#my_transpose' do
    it 'return empty array when given empty array' do
      expect([].my_transpose).to eq([])
    end
    it 'transposes square matrix' do
      arr =     [[0, 1, 2],
                  [3, 4, 5],
                  [6, 7, 8]]
      expect(arr.my_transpose).to eq([[0, 3, 6],
                                      [1, 4, 7],
                                      [2, 5, 8]])
    end
  end

  describe '#stock_picker' do
    it 'returns empty array when given empty array' do
      expect([].stock_picker).to eq([])
    end
    it 'returns empty array if always decreases' do
      expect([3,2,1].stock_picker).to eq([])
    end

    it 'returns best option for simple increase' do
      expect([1,2].stock_picker).to eq([0,1])
    end

    it 'returns best option for long sequence' do
      expect([1,3,2,6,3,0,6].stock_picker).to eq([5, 6])
    end
  end
end
