class Array

  def my_uniq
    unique = []
    self.each do |el|
      unique << el unless unique.include?(el)
    end
    unique
  end

  def two_sum
    pairs = []
    self.each_with_index do |el, index1|
      self[index1+1..-1].each_with_index do |element, index2|
        if el+element == 0
          pairs << [index1,index1 + index2 + 1]
        end
      end
    end
    pairs
  end

  def my_transpose
    len = self.length
    duped = Array.new(len) {Array.new(len)}
    self.each_with_index do |row, y|
      row.each_with_index do |el, x|
        duped[x][y] = el
      end
    end

    duped

  end

  def stock_picker
    profit = 0
    days = []
    self.each_with_index do |buy, day1|
      self[day1+1..-1].each_with_index do |sell, days_away|
        if sell-buy > profit
          profit = sell-buy
          days = [day1, day1 + days_away + 1]
        end
      end
    end
    days
  end
end
