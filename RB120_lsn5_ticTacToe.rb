# => RB120 Object Oriented Programming
# => Lesson 5 Slightly Larger OO Programs
# => March 2-10, 2019
# => David George 
# => dmg2go@gmail.com
# => RB120_lsn5_ticTacToe.rb

require 'pry'

class Game
  GAME_PROMPTS = {new_game: "Want to a_play Tic Tac Toe?", new_mark_board: "Select a cell to mark ... (by number)"}
  VALID_USER_RESPONSES = [:Yes, :No, :Y, :N, :y, :n]
  PLAYER_TYPES = [:user, :opponent]

  attr_reader :board, :user, :opponent

  def initialize
    @board = Board.new
    @user = Player.new(:user, 'U')
    @opponent = Player.new(:opponent, 'C')
    @current_player = @user
    @current_play = nil
    @score = Score.new
    # binding.pry
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
    reset_board

    # main game play loop
    while @game_state == 'active' do
      # take a turn - flip flop player turns
      # @current_play = @current_player == @user ? get_user_play(@board, GAME_PROMPTS[:new_mark_board]) : @current_play = opponent.mark_board(@board, "Computer is playing ...")

      if @current_player == @user
        @current_play = @current_player.get_user_play(@board, GAME_PROMPTS[:new_mark_board])
      elsif @current_player == @opponent
        @current_play = opponent.mark_board(@board, "Computer is playing ...")
      end

      @board.mark_square_at(@current_play, @current_player.marker)
      
      sc = @score.score_current_play(@current_play, @current_player)
      binding.pry
      show_board
      
      @game_state = sc
      binding.pry

      if @game_state != 'active'
        binding.pry
        puts "Game OVER!! >>>  #{@game_state}"
        play_again? 
      else
        @current_player = toggel_player(current_player)
      end
    end
  end

  def toggel_player(current_player)
    @current_player == @user ? @opponent : @user
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
  attr_reader :type, :marker, :rival_mark

  def initialize(type, marker)
    @type = type
    @marker = marker
    @rival_mark = get_rival_mark  #  @marker == 'U' ? 'C' : 'U'
  end

  def get_user_play(game_board, user_prompt)
    a_play = nil
    until a_play do
      puts user_prompt
      a_play = gets.chomp!
      if valid_play?(a_play, game_board.available_squares)
        consume_play(a_play, game_board.available_squares)
      else
        puts "play is invalid: choose a valid play!"
        a_play = nil
      end
    end
    a_play
  end

  def select_opponent_play(game_board, rival_mark)
    a_play = nil

    until a_play do
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

  def get_rival_mark
    @marker == 'U' ? 'C' : 'U'
  end

  private
  def consume_play(a_play, available_squares)
    available_squares.delete(a_play)
  end

  def valid_play?(a_play, available_squares)
    available_squares.include?(a_play) ? true : false
  end
end

class Judge
  attr_reader :rule_book
  def initialize
    # @rule_book = RuleBook.new
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

class Score # an instance of Score changes state with each play, throughout life of game
  attr_reader :won_set, :tie_set, :in_play_set, :near_score_sets, :empty_sets, :score_sets

  def initialize
    score_set_names = ["123", "456", "789", "147", "258", "369", "159", "753"].freeze
    @score_sets = {}
     # hashs are in form of {name: state_as_string}
    @won_set, @draw_sets, @in_play_sets, @near_loss_sets, @near_win_sets = {}, {}, {}, {}, {}

    score_set_names.each do |name|

      a_score_set = WinSet.new.scoring_set
      a_score_set[:ordered_ids].store(name[0].to_sym, name[0].to_i)
      a_score_set[:ordered_ids].store(name[1].to_sym, name[1].to_i)
      a_score_set[:ordered_ids].store(name[2].to_sym, name[2].to_i)

      @score_sets.store(name.to_sym, a_score_set)
    end
  end

  # called LN: 68 @score.update_score(@current_play, current_player)
  def score_current_play(this_play, player)
    player_mark = player.marker
    rival_mark = player.rival_mark

    update_score_sets(this_play, player_mark)
    analyze_score_sets(player_mark, rival_mark)
    report_score(player_mark, rival_mark)

  end

  private
  def update_score_sets(this_play, player_mark)
    score_sets.each_pair do |name, a_score_set|
      a_score_set[:ordered_ids].each_pair do |key, value| 
        if this_play == key.to_s
          a_score_set[:ordered_ids][key] = player_mark
          player_mark == 'U' ? a_score_set[:u_count] += 1 : a_score_set[:c_count] += 1
          a_score_set[:state] = "in_play"
          # binding.pry
        end
      end

    end
  end

  def analyze_score_sets(player_mark, rival_mark)

    @score_sets.each_pair do |name, a_score_set|
      # @won_set = nil, @draw_sets = [], @in_play_sets = [], @near_loss_sets = [], @near_win_sets = [], @empty_sets = []
      player_mark_count = a_score_set[:ordered_ids].values.count(player_mark)
      rival_mark_count = a_score_set[:ordered_ids].values.count(rival_mark)
      
      if player_mark_count == 3
        @won_set.store(name, player_mark)
      elsif rival_mark_count == 3
        @won_set.store(name, rival_mark)
      elsif player_mark_count == 2
        @near_win_sets.store(name, player_mark)
        @near_loss_sets.store(name, rival_mark)
      elsif rival_mark_count == 2
        @near_win_sets.store(name, rival_mark)
        @near_loss_sets.store(name, player_mark)
      binding.pry
      elsif player_mark_count == 1
        #binding.pry
        @in_play_sets.store(name, player_mark)

      elsif rival_mark_count == 1
        @in_play_sets.store(name, rival_mark)
      elsif player_mark_count + rival_mark_count == 3
        @draw_sets.store(name, 'T')
      end
      # a_score_set[:ordered_ids].each_pair do |key, value|
      #   puts key
      #   puts value
      #   binding.pry
      # end # end inner do loop
    end
    # binding.pry
  end
  # binding.pry
  def report_score(player_mark, rival_mark)
    binding.pry
    unless @won_set.empty?
      if @won_set[:name] == player_mark
        " Player won!"
      else
        "Rival won!"
      end
    end

    if @draw_sets.values.count == 8
      "Game ends in a tie!"
    else
      "active"
    end
  end

end

class WinSet
  attr_accessor :scoring_set

  def initialize
    @scoring_set = {ordered_ids: {}, state: WinSetState.new.current_state, u_count: 0, c_count: 0}
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

















































