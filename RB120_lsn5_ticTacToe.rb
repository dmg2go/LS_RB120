# => RB120 Object Oriented Programming
# => Lesson 5 Slightly Larger OO Programs
# => March 2-10, 2019
# => David George 
# => dmg2go@gmail.com
# => RB120_lsn5_ticTacToe.rb

require 'pry'

class Game
  GAME_PROMPTS = {new_game: "Want to a_play Tic Tac Toe?", new_a_play: "Select a cell to mark ... (by number)"}
  VALID_USER_RESPONSES = [:Yes, :No, :Y, :N, :y, :n]
  PLAYER_TYPES = [:user, :opponent]

  attr_reader :board, :user, :opponent, :game_state

  def initialize
    @board = Board.new
    @user = Player.new(:user, 'U', "active")
    @opponent = Player.new(:opponent, 'C', "active")
    self.run_game
  end

  def show_board
     @board.show
  end

  def play_new_game?
    response_is_valid = false

    until response_is_valid do
      puts GAME_PROMPTS[:new_game]
      user_reply = gets.chomp
      if VALID_USER_RESPONSES.include?(user_reply.to_sym)
        return user_reply[0].downcase == 'y' ? 'active' : exit_game
      end
    end
  end

  def play_again?
    restore_board
    play_new_game?
  end

  def run_game
    @game_state = "new"
    @game_state = play_new_game? # sets to 'active' or false
    show_board # don't need as play_game? triggers exit_game  unless @game_state == false
    current_player = @user

    while @game_state == 'active' do
      if current_player == @user
        user.move(@board, GAME_PROMPTS[:new_a_play])
      elsif current_player == @opponent
        opponent.move(@board, '')
      end

      show_board
      @game_state = score_game

      if @game_state != active
        puts @game_state
        play_again? 
      else
        current_player = toggel_player(current_player)
      end
    end
  end

  def toggel_player(current_player)
    current_player == @user ? @opponent : @user
  end

  def restore_board
    @board.restore_board 
    show_board
  end

  def score_game
    case @board.judge_score
    when 'U'
      then @game_state = "User won!"
    when 'C'
      then @game_state = "Computer won!"
    when 'T'
      then @game_state = 'Declare tied ...'
    when 'A'
      then @game_state = 'active'
    end
    @game_state
  end

  def exit_game
    @game_state = nil
    puts "Thanks for playing Tic Tac Toe."
    exit(true)
  end
end

class Player
  # unused 3/8/19 VALID_PLAYER_STATUS = ["winner", "loser", "tied"]
  attr_reader :a_play, :type, :marker # , :status

  def initialize(type, marker, status)
    @type = type
    @marker = marker
    # @status = status  # unused
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
      # A winning set contains all marks of a single player indicates a win (and loss)
      if @squares[winning_array[0]] == @squares[winning_array[1]] 
      && @squares[winning_array[1]] == @squares[winning_array[2]]
        return @squares[winning_array[0]].to_s

      # all winning sets contain marks of both players
      elsif @win_sets.all?{|w_a| w_a.any?("U") && w_a.any?("C")} 
        return "T"
      else
        return "A" # should never get here, but return A for 'active ' @game_state
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

















































