# => RB120 Object Oriented Programming
# => Lesson 5 Slightly Larger OO Programs
# => March 2, 2019
# => David George 
# => dmg2go@gmail.com
# => RB120_lsn5_ticTacToe.rb

require 'pry'

class Game
  GAME_PROMPTS = {new_game: "Want to a_play Tic Tac Toe?", new_a_play: "Select a cell to mark ... (by number)"}
  VALID_USER_RESPONSES = [:Yes, :No, :Y, :N, :y, :n]
  PLAYER_TYPES = [:user, :opponent]

  attr_reader :board, :user, :opponent

  def initialize
    @board = Board.new
    @user = Player.new(:user, 'U', "active")
    @opponent = Player.new(:opponent, 'C', "active")
    self.play_game # if self.play?
  end

  def show_board
     @board.show
  end

  def run_game?
    response_is_valid = false
    
    until response_is_valid do
      puts GAME_PROMPTS[:new_game]
      user_reply = gets.chomp
     # binding.pry
      if VALID_USER_RESPONSES.include?(user_reply.to_sym)
        #response_is_valid = true
        #user_reply = 'Yes' if user_reply[0].downcase == 'y'
        return user_reply[0].downcase == 'y' ? true : false
        #response_is_valid = user_reply[0].downcase == 'y' ? true : false
        #binding.pry
      end
    end
    #user_reply[0] == 'Y' ? true : false
  end

  def play_game
    want_to_play = run_game?
    binding.pry
    show_board if want_to_play
    current_player = @user
    while want_to_play do

      if current_player == @user
        user.move(@board, GAME_PROMPTS[:new_a_play])
      elsif current_player == @opponent
        opponent.move(@board, '')
      end

      show_board
      if game_over?
        want_to_play = run_game?
        binding.pry
        if want_to_play
          restore_board
        else
          puts "Thanks for playing Tic Tac hotDog"
          break
        end
        next
      end
      current_player = toggel_player(current_player)
    end
  end

  def toggel_player(current_player)
    current_player == @user ? @opponent : @user
  end

  def restore_board
    @board.restore_board 
    show_board
  end

  def game_over?
    case @board.judge_score
    when 'U'
      then "User won!"
    when 'C'
      then "Computer won!"
    when 'T'
      then 'Declare tied ...'
    else
      @board.available_squares.empty? ? 'declare tied' : false
    end
  end
end

class Player
  VALID_PLAYER_STATUS = ["active", "winner", "loser", "tied"]
  attr_reader :a_play, :type, :marker, :status

  def initialize(type, marker, status)
    @type = type
    @marker = marker
    @status = status 
  end

  def move(game_board, move_prompt)
    #this_play = nil
    if self.type == :user
      this_play = select_user_play(game_board, move_prompt)
    elsif self.type == :opponent
      this_play = select_opponent_play(game_board)
    end
    game_board.mark_square_at(this_play, self)

  end

  private
  def select_user_play(game_board, move_prompt)
    @a_play = nil
    until @a_play do
      puts move_prompt
      @a_play = gets.chomp

      if valid_play?(@a_play, game_board.available_squares)
        consume_play(@a_play, game_board.available_squares) # returns deleted item @a_play
      else
        puts "play is invalid: choose a valid play!"
        @a_play = nil
      end
    end
    @a_play
  end

  def select_opponent_play(game_board)
    @a_play = nil
    until @a_play do
      @a_play = game_board.available_squares.sample
      # binding.pry
      if valid_play?(@a_play, game_board.available_squares)
        puts "Computer selects #{@a_play} ..."
        consume_play(@a_play, game_board.available_squares)
      else
        @a_play = nil
      end
    end
    # binding.pry
    @a_play
  end

  def consume_play(a_play, available_squares)
    available_squares.delete(a_play)
  end

  def valid_play?(a_play, available_squares)
    available_squares.include?(a_play) ? true : false
  end
end

class Board
  attr_reader :available_squares

  def initialize
    @available_squares = ['1', '2', '3', '4', '5', '6', '7', '8', '9']
    @squares = {}
    (1..9).each {|key| @squares[key] = Square.new(key.to_s)}
    @win_sets = [[1, 2 , 3], [4, 5, 6], [7, 8, 9], [1, 5, 9], [3, 5, 7], [1, 4, 7], [2, 5, 8], [3, 6, 9]]
  end

  def show
    puts ""
    puts "     |     |"
    puts "  #{self.get_square_at(1)}  |  #{self.get_square_at(2)}  |  #{self.get_square_at(3)}  "
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{self.get_square_at(4)}  |  #{self.get_square_at(5)}  |  #{self.get_square_at(6)}  "
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{self.get_square_at(7)}  |  #{self.get_square_at(8)}  |  #{self.get_square_at(9)}  "
    puts "     |     |"
    puts ""
  end

  def restore_board
    @available_squares = ['1', '2', '3', '4', '5', '6', '7', '8', '9']
    (1..9).each {|key| @squares[key] = Square.new(key.to_s)}
  end

  def get_square_at(key)
    @squares[key]
  end

  def mark_square_at(key, player)
    @squares[key.to_i] = player.marker
    p @squares[key.to_i]
    # binding.pry
  end

  def judge_score
    @win_sets.each do |winning_array|
      if @squares[winning_array[0]] == @squares[winning_array[1]] && @squares[winning_array[1]] == @squares[winning_array[2]]
        return @squares[winning_array[0]].to_s
      
      elsif @win_sets.all?{|w_a| w_a.any?("U") && w_a.any?("C")}
        binding.pry
        "T"
      end
    end
  end
end

class Square
  def initialize (marker)
    @marker = marker
  end

  def to_s
    @marker
  end
end

g = Game.new

















































