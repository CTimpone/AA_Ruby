require_relative 'board.rb'
require_relative 'piece.rb'

class Checkers

  def initialize
    @board=Board.standard_board
    @turn = :black
  end

  def run
    puts 'Welcome to Checkers!  Enjoy the game!'
    until over?
      begin
        puts @board.inspect
        puts "#{@turn.to_s.capitalize} turn: What move would you like to make (enter in format of f2, e3, d2)?"
        input = gets.chomp.split(', ')
        if input.length < 2
          raise CheckersError.new "Please re-enter a move in the valid format."
        end
        sequence = []

        input.each do |string|
          sequence << Board.translate(string)
        end

        @board.move(sequence, @turn)
      rescue CheckersError => e
        puts "Error: #{e}"
        retry
      end

      @turn = other_color
    end

    if win?
      puts "Hooray! #{other_color} wins."
    else
      puts 'What a waste.  No remaining moves.  Stale game.'
    end
  end

  def win?
    @board.controlled_pieces(@turn).empty?
  end

  def stale?
    @board.controlled_pieces(@turn).all? {|piece| piece.move_count.zero?}
  end

  def other_color
    (@turn == :white ? :black : :white)
  end

  def over?
    win? || stale?
  end
end

if __FILE__ == $PROGRAM_NAME
  puts "Human v Human Checkers Grudge Match!"
  Checkers.new.run
end
