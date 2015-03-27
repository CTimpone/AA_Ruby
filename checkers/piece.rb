# encoding: UTF-8

require_relative 'checkers_error.rb'

class Piece

  DELTAS = {
    :black => [[-1,1], [-1, -1]],
    :white => [[1, 1], [1, -1]]
  }

  attr_reader :color
  attr_accessor :pos, :king

  def initialize(color, pos, board, king = false)
    @color = color
    @pos = pos
    @board = board
    @king = king

    @board[pos] = self
  end

  def perform_moves!(move_sequence)
    if move_sequence.length == 1
      move_sequence = move_sequence.flatten

      if valid_slides.include?(move_sequence)
        if @board.no_jumps?(color)
          self.perform_slide(move_sequence)
        else
          raise CheckersError.new ("You must jump.")
        end
      elsif valid_jumps.include?(move_sequence)
        self.perform_jump(move_sequence)
      else
        raise CheckersError.new("First move not included.")
      end

    elsif move_sequence.length > 1

      until move_sequence.empty?
        if valid_jumps.keys.include?(move_sequence.first)
          self.perform_jump(move_sequence.first)
        else
          raise CheckersError.new("All moves not included.")
        end
        move_sequence.shift
      end

    end
  end

  def valid_move_sequence?(move_sequence)
    duped_pos = self.pos
    duped = @board.dup
    duped[duped_pos[0], duped_pos[1]].perform_moves!(move_sequence)

    true
  end

  def perform_moves(move_sequence)
    duped_moves = move_sequence.dup
    if valid_move_sequence?(duped_moves)
      perform_moves!(move_sequence)
    end
  end

  def perform_slide(new_pos)
    new_pos = new_pos.flatten
    slides = valid_slides
    if !slides.include?(new_pos)
      return false
    else
      @board[pos] = nil
      @pos = new_pos
      @board[new_pos] = self
    end

    if back_row?
      self.king = true
    end

    true
  end

  def perform_jump(new_pos)
    new_pos = new_pos.flatten
    jumps = valid_jumps

    if !jumps.keys.include?(new_pos)
      return false

    else
      jump_over = jumps[new_pos]
      @board[pos] = nil
      @board[jump_over] = nil
      self.pos = new_pos
      @board[new_pos] = self
    end

    if back_row?
      self.king = true
    end

    true
  end

  def valid_slides
    all_moves = []

    move_directions.each do |dx, dy|
      move = [pos[0] + dx, pos[1] + dy]
      all_moves << move
    end

    valid_slides = all_moves.select{ |move| slide_into?(move)}
  end

  def valid_jumps
    all_first_moves = Hash.new{|k,v| k[v] = nil}
    valid_jumps = Hash.new{|k,v| k[v] = nil}

    move_directions.each do |dx, dy|
      move = [pos[0] + dx, pos[1] + dy]
      all_first_moves[move] = [dx, dy]
    end

    potential_jumps = all_first_moves.select{ |move, deltas| jump_over?(move)}

    potential_jumps.each do |move, deltas|
      new_pos = [move[0]+deltas[0], move[1] + deltas[1]]
      valid_jumps[new_pos] = move if slide_into?(new_pos)
    end

    valid_jumps
  end

  def move_count
    valid_jumps.count + valid_slides.count
  end

  def slide_into?(pos)
    @board.in_bounds?(pos) && @board.not_occupied?(pos)
  end

  def jump_over?(pos)
    @board.occupied_by_other_color?(pos, color)
  end

  def move_directions
    king ? DELTAS[color] : DELTAS[other_color]
  end

  def back_row?
    if color == :white && pos[0] == 0
      return true
    elsif color == :black && pos[0] == 7
      return true
    end

    false
  end

  def render
    if king
      color == :white ? '♔' : '♚'
    else
      color == :white ? '⓪' : '⓿'
    end
  end

  def other_color
    color == :white ? :black : :white
  end

end
