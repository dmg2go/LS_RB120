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
    @current_score = WinSets.new
    @judge = Judge.new
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
    current_player = @user
    reset_board

    # main game play loop
    while @game_state == 'active' do
      if current_player == @user
        user.move(@board, GAME_PROMPTS[:new_move], @current_score)
      elsif current_player == @opponent
        opponent.move(@board, '')
      end

      show_board
      @current_score.report_score
      binding.pry
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

  def move(game_board, move_prompt, current_score)
    rival_mark = nil
    if self.type == :user
      this_play = user_play(game_board, move_prompt)
      rival_mark = 'C'
    elsif self.type == :opponent
      rival_mark = 'U'
      this_play = select_opponent_play(game_board, rival_mark)
    end
    game_board.mark_square_at(this_play, self.marker)
    current_score.update_score(this_play, self.marker, rival_mark)

  end

  private
  def user_play(game_board, move_prompt)
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

class WinSets
  def initialize
    @win_sets = {}
    win_set_names = ["123", "456", "789", "147", "258", "369", "159", "753"].freeze
    
    win_set_names.each do |name|

      a_score_set = WinSet.new.scoring_set
      a_score_set[:ordered_ids].store(name[0].to_sym, name[0].to_i)
      a_score_set[:ordered_ids].store(name[1].to_sym, name[1].to_i)
      a_score_set[:ordered_ids].store(name[2].to_sym, name[2].to_i)

      @win_sets.store(name.to_sym, a_score_set)
    end
  end

  def report_score
    puts "return the score"
    binding.pry
  end

  def update_score(valid_play, player_mark, rival_mark)
    update_sets(valid_play, player_mark)
    binding.pry
    ranked_threats = check_sets_for_threats(rival_mark)
    binding.pry
    ranked_wins = check_sets_for_wins(player_mark)
    binding.pry
  end

  def update_sets(valid_play, player_mark)
    @win_sets.each_pair do |name, ws|

      ws[:ordered_ids].each_pair do |key, value| 
        # binding.pry
        if valid_play == key.to_s
          value = player_mark
          binding.pry
        end
      end
    end
  end


  def check_sets_for_threats(rival_mark)
    ranked_threat_sets = {}
    @win_sets.each do |ws|
      rival_mark_count = 0
      ws[:ordered_ids].each_pair do |key, value| 
        binding.pry
        puts key
        puts value
      end

        #rival_mark_count += 1 if value = rival_mark }
      ranked_threat_sets.store(ws.name, rival_mark_count)
    end
  end
  # binding.pry
end

class WinSet
  attr_accessor :scoring_set

  def initialize
    @scoring_set = {ordered_ids: {}, state: WinSetState.new.current_state, my_mark_count: 0, rival_mark_count: 0}
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

















































