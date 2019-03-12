# => RB120 Object Oriented Programming
# => Lesson 5 Slightly Larger OO Programs
# => March 2-10, 2019
# => David George 
# => dmg2go@gmail.com
# => RB120_lsn5_ticTacToe.rb

require 'pry'

class Game
  GAME_PROMPTS = {new_game: "Want to a_play Tic Tac Toe?", new_move: "Select a cell to mark ... (by number)"}
  VALID_USER_RESPONSES = [:Yes, :No, :Y, :N, :y, :n]
  PLAYER_TYPES = [:user, :opponent]

  attr_reader :board, :user, :opponent, :game_state, :judge

  def initialize
    @board = Board.new
    @user = Player.new(:user, 'U')
    @opponent = Player.new(:opponent, 'C')
    @judge = Judge.new
    binding.pry
    self.play_new_game?
  end

  def show_board
     @board.show
  end

  def play_new_game?
    response_is_valid = false

    until response_is_valid do
      puts GAME_PROMPTS[:new_game]
      user_reply = gets.chomp!
      if VALID_USER_RESPONSES.include?(user_reply.to_sym)
        return user_reply[0].downcase == 'y' ? run_game : exit_game
      else
        puts "Please enter y for yes or n for no ..."
      end
    end
  end

  def play_again?
    binding.pry
    play_new_game?
  end

  def run_game
    @game_state = "active"
    current_player = @user
    reset_board

    # main game play loop
    while @game_state == 'active' do
      if current_player == @user
        user.move(@board, GAME_PROMPTS[:new_move])
      elsif current_player == @opponent
        opponent.move(@board, '')
      end

      show_board
      @game_state = score_game

      if @game_state != 'active'
        binding.pry
        puts "Game OVER!! >>>  #{@game_state}"
        play_again? 
      else
        current_player = toggel_player(current_player)
      end
    end
  end

  def toggel_player(current_player)
    current_player == @user ? @opponent : @user
  end

  def reset_board
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
      then @game_state = 'Declare tie ...'
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
  attr_reader :a_play, :type, :marker

  def initialize(type, marker)
    @type = type
    @marker = marker
  end

  def move(game_board, move_prompt)
    if self.type == :user
      this_play = select_user_play(game_board, move_prompt)
    elsif self.type == :opponent
      this_play = select_opponent_play(game_board, 'U')
    end
    game_board.mark_square_at(this_play, self.marker)

  end

  private
  def select_user_play(game_board, move_prompt)
    @a_play = nil
    until @a_play do
      puts move_prompt
      @a_play = gets.chomp!

      if valid_play?(@a_play, game_board.available_squares)
        consume_play(@a_play, game_board.available_squares)
      else
        puts "play is invalid: choose a valid play!"
        @a_play = nil
      end
    end
    @a_play
  end

  def select_opponent_play(game_board, rival_mark)
    @a_play = nil

    until @a_play do
      binding.pry
      if valid_play?(@a_play, game_board.available_squares)
        puts "Computer selects #{@a_play} ..."
        consume_play(@a_play, game_board.available_squares)
      else
        @a_play = nil
      end
      binding.pry
    end
    binding.pry
    @a_play
  end

  def consume_play(a_play, available_squares)
    available_squares.delete(a_play)
  end

  def valid_play?(a_play, available_squares)
    available_squares.include?(a_play) ? true : false
  end
end

class Judge
  attr_accessor :current_score

  def initialize
    @current_score = WinSets.new
    binding.pry
  end

end


class Board
  attr_reader :available_squares, :winable_sets, :squares

  def initialize
    @squares = {}
    @winable_sets = [[1, 2, 3], [4, 5, 6], [7, 8, 9], [1, 5, 9], [3, 5, 7], [1, 4, 7], [2, 5, 8], [3, 6, 9]]
    restore_board
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

  def mark_square_at(key, marker)
    @squares[key.to_i] = marker
    p @squares[key.to_i]
    # binding.pry
  end

  def judge_score
    @winable_sets.each do |winning_array|
      if @squares[winning_array[0]] == @squares[winning_array[1]] && @squares[winning_array[1]] == @squares[winning_array[2]]
        return @squares[winning_array[0]]
      end
      # all winning sets contain marks of both players
      if @winable_sets.all?{|w_a| w_a.any?("U") && w_a.any?("C")} 
        binding.pry
        return "T"
      end
    end
    # return A for 'active' if no game resolution
    return "A"
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

class WinSets
  def initialize
    @win_sets = {}
    win_set_names = ["123", "456", "789", "147", "258", "369", "159", "753"].freeze
    
    win_set_names.each do |name|

      a_score_set = WinSet.new.scoring_set
      a_score_set[:ordered_ids][:k0] = name[0].to_i
      a_score_set[:ordered_ids][:k1] = name[1].to_i
      a_score_set[:ordered_ids][:k2] = name[2].to_i

      @win_sets.store(name.to_sym, a_score_set)
      
    end
  end
  # binding.pry
end

class WinSet
  attr_accessor :scoring_set

  def initialize
    @scoring_set = {ordered_ids: {k0: nil, k1: nil, k2: nil}, state: WinSetState.new.current_state, my_mark_count: 0, rival_mark_count: 0}
    # {ordered_ids: {k0: nil, k1: nil, k2: nil}, state: WinSetState.new, my_mark_count: 0, rival_mark_count: 0}
  end

  def scoring_set
    @scoring_set
  end

  def update_scoring_set
    puts "update win set? coming soon!"
  end
end

class WinSetState
  attr_reader :state_of_set
  attr_accessor :current_state
  
  def initialize
    @state_of_set = ["empty", "in_play", "full", "won"]
    @current_state = @state_of_set[0]
    
  end

  def current_state
    
    @current_state
  end

  def change_state(new_state)
    if @state_of_set.include?(new_state)
      current_state = new_state
    end
    # if current_state == "empty"
    #   current_state = "in_play"
    # elsif current_state == "in_play"
    #   current_state = "full"
    # elsif current_state == "full"
    #   current_state == "won"
  end
end


g = Game.new

















































