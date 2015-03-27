require_relative 'piece.rb'
require 'colorize'

class Board

  TRANSLATED = {
    'a' => 0,
    'b' => 1,
    'c' => 2,
    'd' => 3,
    'e' => 4,
    'f' => 5,
    'g' => 6,
    'h' => 7,
  }
  attr_reader :grid

  def self.translate(string)
    col = string[0].downcase
    if !TRANSLATED.include?(col)
      raise CheckersError.new "Invalid move entry.  Please use the proper format."
    else
      col = TRANSLATED[col]
    end
    begin
      row = Integer(string[1])
    rescue ArgumentError
      raise CheckersError
    else
      row = 8 - row
    end

    [row, col]
  end

  def self.standard_board
    board = Board.new

    rows = [[:black, 0], [:black, 1], [:black, 2],
            [:white, 5], [:white, 6], [:white, 7]]

    rows.each do |color, row|
      count = (row.odd? ? 0 : 1)
      4.times do
        col = count
        Piece.new(color, [row, col], board)
        count += 2
      end
    end

    board
  end

  def self.stale_board
  board = Board.new

  rows = [[:black, 0], [:black, 1],
          [:white, 2], [:white, 3]]

  rows.each do |color, row|
    count = (row.odd? ? 0 : 1)
    4.times do
      col = count
      Piece.new(color, [row, col], board)
      count += 2
    end
  end

  Piece.new(:white, [5, 0], board)
  board
  end

  def self.double_jump_board
    board = Board.new
    Piece.new(:black, [0,3], board)
    Piece.new(:white, [1,4], board)
    Piece.new(:white, [3,4], board)

    board
  end

  def initialize
    @grid = Array.new(8) { Array.new(8) }
  end

  def move(array, color)
    start = array.shift
    piece = @grid[start[0]][start[1]]
    if piece.nil?
      raise CheckersError.new "No piece at chosen location."
    elsif piece.color != color
      raise CheckersError.new "Not your piece."
    else
      piece.perform_moves(array)
    end
  end

  def [](*pos)
    @grid[pos[0]][pos[1]]
  end

  def []=(pos, piece)
    @grid[pos[0]][pos[1]] = piece
  end

  def in_bounds?(pos)
    pos[0].between?(0,7) && pos[1].between?(0,7)
  end

  def occupied_by_other_color?(pos, color)
    !not_occupied?(pos) && self[pos[0], pos[1]].color != color
  end

  def not_occupied?(pos)
    self[pos[0], pos[1]].nil?
  end

  def pieces
    self.grid.flatten.compact
  end

  def controlled_pieces(color)
    controlled_pieces = self.pieces.select {|piece| piece.color == color}
  end

  def no_jumps?(color)
    controlled_pieces(color).each do |piece|
      if !piece.valid_jumps.empty?
        return false
      end
    end

    true
  end

  def dup
    duped = Board.new
    pieces.each do |piece|
      new_pos = piece.pos
      new_king = piece.king
      Piece.new(piece.color, new_pos, duped, new_king)
    end

    duped
  end

  def inspect
    pretty_grid = ""
    pretty_grid <<"   A  B  C  D  E  F  G  H\n"
    background = :red

    8.times do |row|
      pretty_grid << "#{8 - row} "
      background = (background == :white ? :light_red : :white)

      8.times do | col|
        if self[row, col] == nil
          pretty_grid << '   '.colorize(:background => background)
        else
          pretty_grid << " #{self[row, col].render} ".colorize(:background => background)
        end
        background = (background == :white ? :light_red : :white)
      end
      pretty_grid << " #{8 - row} \n"

    end

    pretty_grid <<"   A  B  C  D  E  F  G  H\n"
    pretty_grid
  end
end
