# => RB120 Object Oriented Programming
# => Lesson 5 Slightly Larger OO Programs
# => March 2, 2019
# => David George 
# => dmg2go@gmail.com
# => RB120_lsn5_ticTacToe.rb

require 'pry'

class Game
  GAME_PROMPTS = {new_game: "Want to a_play Tic Tac Toe?", new_a_play: "Select a cell to mark ... (by number)"}
  VALID_USER_RESPONSES = [:Yes, :No]
  PLAYER_TYPES = [:user, :opponent]

  attr_reader :board, :user, :opponent

  def initialize
    @board = Board.new
    @user = Player.new(:user, 'U', "active")
    @opponent = Player.new(:opponent, 'C', "active")
    self.play_game if self.play?
  end

  def show_board
     @board.show
  end

  def play?
    valid_reply = false
    until valid_reply == true do
      prompt = GAME_PROMPTS[:new_game]
      puts prompt
      user_reply = gets.chomp

      user_reply = 'Yes' if user_reply[0].downcase == 'y'

      if VALID_USER_RESPONSES.include?(user_reply.to_sym)
        valid_reply = true
      end
    end
    user_reply[0] == 'Y' ? true : false
  end

  def play_game
    loop do
      show_board
      user.move(@board, GAME_PROMPTS[:new_a_play])
      show_board
      break if game_over?
      opponent.move(@board, '')
      show_board
      break if game_over?
      binding.pry
      puts "is this the end?"
    end


  end

  def game_over?
    # check if a win or tie occurs - then set game_state to over with resolution
    @board.available_squares.empty? ? true : false
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

  def get_square_at(key)
    @squares[key]
  end

  def mark_square_at(key, player)
    @squares[key.to_i] = player.marker
    p @squares[key.to_i]
    # binding.pry
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

















































