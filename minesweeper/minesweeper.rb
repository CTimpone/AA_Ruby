require 'yaml'
require 'byebug'

class Tile

  attr_accessor :state, :neighbors, :flagged
  attr_reader :has_bomb

  def initialize(has_bomb, state = nil)
    @has_bomb = has_bomb
    @state = state
    @neighbors = []
    @flagged = false
  end

  def reveal
    if has_bomb?
      self.state = :bomb
    else
      self.state = neighbors_bomb_count
    end
    self.state
  end

  def has_bomb?
    has_bomb
  end

  def neighbors_bomb_count
    bomb_count = 0

    neighbors.each do |check|
      bomb_count += 1 if check.has_bomb
    end

    bomb_count
  end

  def inspect
    str = ""

    if state.nil?
      if flagged
        str << " F "
      else
        str << " - "
      end
    else
      if state == :bomb
        str << " B "
      else
        str << " #{state} "
      end
    end
  end

  def neighbor_cascade
    adjacent = self.neighbors


    if !self.neighbors_bomb_count.zero?
      self.reveal
    else
      self.reveal
      adjacent.each do |n_tile|
        if n_tile.state.nil?
          n_tile.reveal
          n_tile.neighbor_cascade
        end
      end
    end
  end

end

class Board

  DEFAULT_BOARD_ATTR = {
    9 => 10,
    4 => 2
    #other sizes
  }

  NEIGHBOR_COORD = [[1,1], [1,0], [1, -1],
                    [0, -1], [-1, -1], [-1, 0],
                    [-1, 1], [0, 1]]

  def self.seed_board(size)
    bomb_count = DEFAULT_BOARD_ATTR[size]

    board = Array.new(size) { Array.new(size) }

    bomb_pos = (1..size ** 2).to_a.sample(bomb_count)

    board = Board.tile_generation(board, size, bomb_pos)
    Board.set_board_neighbors(board, size)


    board
  end

  def self.tile_generation(board, size, bomb_pos)
    start_count = 1

    (0...size).each do |x|
      (0...size).each do |y|
        if bomb_pos.include?(start_count)
          board[x][y] = Tile.new(true)
        else
          board[x][y] = Tile.new(false)
        end

        start_count += 1
      end
    end

    board
  end

  def self.set_board_neighbors(board, size)
    (0...size).each do |x|
      (0...size).each do |y|


        NEIGHBOR_COORD.each do |del|
          neighbor_x = x + del[0]
          neighbor_y = y + del[1]

          if Board.in_board?(neighbor_x, neighbor_y, size)
            board[x][y].neighbors << board[neighbor_x][neighbor_y]
          end
        end

      end
    end
  end

  def self.in_board?(x, y, size)
    x.between?(0, size - 1) && y.between?(0, size - 1)
  end

  attr_reader :board

  def initialize(size = 9)
    @board = Board.seed_board(size)
  end

  def all_tiles
    @board.flatten
  end

  def [](x, y)
    @board[x][y]
  end

  def display
    puts render
  end

  def render
    str = ""
    @board.each do |row|
      str += "#{row}\n"
    end
    str
  end
end

class Minesweeper

  def self.load_game

    game_lines = File.readlines("saves.txt")
    games = []
    debugger

    until game_lines.index("--- !ruby/object:Minesweeper\n").nil?
      start_index = game_lines.index("--- !ruby/object:Minesweeper\n")

      next_index = game_lines[1..-1].index("--- !ruby/object:Minesweeper\n")

      next_index = next_index || game_lines.size - 1

      game = game_lines.take(next_index + 1)
      game_lines = game_lines.drop(next_index + 1)

      games << YAML::load(game.join)
    end

    games
  end


  attr_accessor :board
  def initialize(size)
    @board = Board.new(size)
  end

  def play
    @board.display
    puts "Welcome to Minesweeper!"

    until over?
      turn
    end

    if win?
      puts "Congratulations!"
    else
      puts "Sorry.  Please play again."
    end
  end

  def turn
    p "Would you like to flag a tile [F], reveal a tile [R], or " +
        "save and end this game[S]?"

    input = gets.chomp.downcase

    case input[0]
    when "f"
      flag_tile
    when "r"
      reveal_tile
    when "s"
      save_game
    when "l"
      load_game
    end
  end

  def save_game
    game = self.to_yaml
    File.open("saves.txt", "a") do |f|
      f.puts game
    end
  end

  def reveal_tile
    p "What tile would you like to reveal (enter as x,y)?"
    coord = gets.chomp.split(',').map {|el| el.to_i}

    if @board[*coord].has_bomb?
      @board[*coord].reveal
    else
      neighbor_cascade(@board[*coord])
    end

    @board.display
  end

  def flag_tile
    input = 'y'

    until input != 'y'
      p "What tile would you like to flag (enter as x,y)"

      coord = gets.chomp.split(',').map {|el| el.to_i}

      @board[*coord].flagged = true
      @board.display

      p "Would you like to flag anything else?"
      input = gets.chomp[0].downcase
    end
  end

  def neighbor_cascade(tile)
    tile.neighbor_cascade
  end

  def over?
    return true if win?

    @board.all_tiles.each do |tile|
      if tile.has_bomb?
        return true if tile.state == :bomb
      end
    end

    false
  end

  def win?
    @board.all_tiles.each do |tile|
      if tile.has_bomb?
        return false if tile.state == :bomb
      elsif !tile.has_bomb?
        return false if tile.state.nil?
      end
    end

    true
  end

end

if __FILE__ == $PROGRAM_NAME

  p "Would you like to start a new game[N] or load an existing game[L]?"
  input = gets.chomp.downcase

  if input == "l"
    saves = Minesweeper.load_game
    len = saves.length
    p "There are #{len} saves.  Select one (ex 1 or 2 or 3)"
    save_choice = gets.chomp.to_i
    saves[save_choice].play
  end


  # a = Minesweeper.new(4)
end
