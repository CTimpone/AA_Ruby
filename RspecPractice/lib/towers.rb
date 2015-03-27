class Towers

  attr_accessor :board

  def initialize(board = [[3,2,1], nil, nil])
    @board = board
  end



  def won?
    win = [3,2,1]
    @board[1] == win || @board[2] == win
  end

  def move(array)
    if valid_move?(array)
      if !@board[array[1]].nil?
        @board[array[1]] << @board[array[0]].pop
      else
        @board[array[1]] = [@board[array[0]].pop]
      end
    end

    store = @board.map do |el|
      if el.nil?
        el
      elsif el.empty?
        el = nil
      else
        el
      end
    end

    store
  end



  def valid_move?(array)
    pick = @board[array[0]]
    place = @board[array[1]]
    if pick.nil?
      false
    elsif place.nil?
      true
    elsif pick.last > place.last
      false
    else
      true
    end

  end

end
