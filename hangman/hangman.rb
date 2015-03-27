require 'byebug'

class Hangman

  def initialize(player1, player2)
    @picker = player1
    @guesser = player2
  end

  def run
    len = @picker.pick_secret_word
    @guesser.receive_secret_length(len)
    puts "The word is #{len} characters long."
    turn_count = 1

    until turn_count > 8
      current_guess = @guesser.guess
      display = @picker.check_guess(current_guess)
      p display
      @guesser.guess_array = @picker.secret_array

      if win?
        return "Guesser wins.  It took #{turn_count} turns."
      end

      turn_count += 1

    end

    return "Out of turns.  Picker wins."
  end

  def win?
    !@guesser.guess_array.include?(nil)
  end

end

class HumanPlayer

  attr_reader :secret, :secret_array
  attr_accessor :guess_array

  def initialize
    @used = []
  end

  def pick_secret_word
    puts 'Please enter the length of your word:'

    len = gets.chomp.to_i
    @secret_array = Array.new(len) {nil}

    len
  end

  def receive_secret_length(len)
    @guess_array = Array.new(len) {nil}
  end

  def guess
    puts 'Please enter your letter:'
    guess = gets.chomp[0]

    until !@used.include?(guess)
      puts 'You have already entered that before.  Enter a different value:'
      guess = gets.chomp[0]
    end

    @used << guess
    guess
  end

  def check_guess(guess)
    puts "Does the word contain the letter #{guess}?"
    reply = gets.chomp[0].downcase
    if reply == 'y'
    handle_guess_response(guess)
    display = []
    @secret_array.each do |idx|

        if idx == nil
          display << '_'
        else
          display << idx
        end
      end

      display

    else
      return 'Guess not included.'
    end
  end

  def handle_guess_response(guess)
    reply = nil

    until reply == 0
      puts 'What is the location of the letter (enter single appearance).  Enter 0 if done.'
      reply = gets.chomp.to_i
      @secret_array[reply - 1] = guess unless reply == 0
    end

  end

end

class ComputerPlayer

  attr_reader :secret, :secret_array
  attr_accessor :guess_array

  def initialize
    @used = []
    dic = []
    File.open('dictionary.txt').each_line {|word| dic << word.chomp}
    @dictionary = dic
  end

  def pick_secret_word
    @secret = @dictionary.sample

    len = @secret.length
    @secret_array = Array.new(len) {nil}

    len
  end

  def receive_secret_length(len)

    @guess_array = Array.new(len) {nil}
    @dictionary = @dictionary.select {|word| word.length == len}
  end

  def guess

    cull_dictionary
    smart_guess
  end

  def smart_guess
    letter_count = Hash.new {|k,v| k[v] = 0}

    @dictionary.each do |word|
      word.each_char do |letter|
        letter_count[letter] += 1
      end
    end

    @used.each do |letter|
      letter_count.delete(letter)
    end

    guess = (letter_count.max_by {|k, v| v})[0]

    @used << guess

    guess
  end

  def cull_dictionary
    check = (@guess_array - [nil]).length
    empt = []

    @dictionary.each do |word|
      match_count = 0
      @guess_array.each_with_index do |letter, idx|
        if (word[idx] == letter)
          match_count += 1
        elsif @used.include?(word[idx])
          match_count = -1
        end
      end

      if match_count == check
        empt << word
      end
    end

    @dictionary = empt
  end

  def check_guess(guess)
    if @secret.include?(guess)
      handle_guess_response(guess)
      display = []
      @secret_array.each do |idx|

        if idx == nil
          display << '_'
        else
          display << idx
        end
      end

      display

    else
      return 'Guess not included.'
    end

  end
  def handle_guess_response(guess)
    count = 0

    @secret.each_char do |letter|

      if letter == guess
        @secret_array[count] = letter
      end

      count += 1
    end

  end

end

if __FILE__ == $PROGRAM_NAME
  print "Is the picker a computer?"
  if gets.chomp == "yes"
    player1 = ComputerPlayer.new
  else
    player1 = HumanPlayer.new
  end
  print "Is the guesser a computer? "
  if gets.chomp == "yes"
    player2 = ComputerPlayer.new
  else
    player2 = HumanPlayer.new
  end
  Hangman.new(player1, player2).run
end
