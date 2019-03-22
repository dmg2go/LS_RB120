# => RB120 Object Oriented Programming
# => Lesson 5 Slightly Larger OO Programs
# => March 2-22, 2019
# => David George 
# => dmg2go@gmail.com
# => RB120_lsn5_ticTacToe.rb

require 'pry'

class Game
  GAME_PROMPTS = {new_game:       "Want to play Tic Tac Toe?", 
                  new_mark_board: "Select a square to play ... (by number)"}
  VALID_USER_RESPONSES = [:Yes, :No, :Y, :N, :y, :n]
  PLAYER_TYPES = [:user, :opponent]

  attr_reader :board, :user, :opponent, :score

  def initialize
    @board = Board.new
    @user = Player.new(:user, 'U')
    @opponent = Player.new(:opponent, 'C')
    @current_player = @user
    @current_play = nil
    @score = Score.new
    self.play_new_game?
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

  def run_game
    score.current_score = "active"
    reset_game
    # main game play loop
    while score.current_score == 'active' do
      # take a turn - toggle player as current_player each turn to get play
      if @current_player == user
        @current_play = user.get_user_play(@board, GAME_PROMPTS[:new_mark_board])
      elsif @current_player == opponent
        @current_play = opponent.computes_move(@board, @score, "Computer is choosing a move ...")
      end

      board.mark_square_at(@current_play, @current_player.marker)
      score.eval_this_play(@current_play, @current_player)
      board.show
      if score.current_score == "game over"
        score.report
        play_again? 
      end

      @current_player = toggel_player(@current_player)
    end
  end

  def toggel_player(current_player)
    @current_player == @user ? @opponent : @user
  end

  def reset_game
    board.restore_board
    score.reset
    board.show
    @current_player = @user
  end

  def play_again?
    play_new_game?
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

  def computes_move(game_board, score, msg_to_user)
    a_play = nil
    puts msg_to_user

    while a_play == nil
      if first_user_play?(game_board)
        a_play = best_first_play(score)

      elsif can_win?(score)
        a_play = winning_move(score)
         #binding.pry

      elsif can_lose?(score)
        a_play = blocking_move(score)
         #binding.pry

      elsif can_add_to_row?(score)
        a_play = building_move(score, game_board)
        #binding.pry
      else
        binding.pry
        a_play = game_board.available_squares.sample
      end

      if valid_play?(a_play, game_board.available_squares)
        puts "Computer has chosen a move: #{a_play} ..."
        consume_play(a_play, game_board.available_squares)
      else
        a_play = nil
      end
    end # end while loop
    #binding.pry
    a_play
  end

  def get_rival_mark
    @marker == 'U' ? 'C' : 'U'
  end

  private

  def first_user_play?(board)
    board.available_squares.count == 8
  end

  def best_first_play(score)
    user_marked = nil
    score.scoring_row_set.scored_rows.each_pair do |name, scored_row|
      if scored_row.data[:u_count] == 1
        scored_row.data[:row_marks].each_pair do |index, mark|
          user_marked = index.to_s if mark == 'U'
        end # end scored_row.data[:row_marks].each_pair do
      end # end if scored_row.data[:u_count] == 1
    end # score.scoring_row_set.scored_rows.each_pair do

    if user_marked == '5'
      ['1', '3', '7', "9"].sample # does not matter, cannot win without user mistake
    else
      '5' # center is the best move
    end
  end

  def can_win?(score)
    a_play = nil
    score.scoring_row_set.scored_rows.each_pair do |name, scored_row|
      if scored_row.data[:c_count] == 2 && scored_row.data[:u_count] == 0 # requires immediate block
        scored_row.data[:row_marks].each_pair do |key, square|
        if square != 'C' # square.to_i.class == Integer 
          a_play = square
         end
       end
      end
      #binding.pry
      break if a_play != nil
    end # enod of score.scoring_row_set.each do
   #binding.pry
    a_play
  end

  def winning_move(score)
    can_win?(score)
  end

  def can_lose?(score)
    a_play = nil
    #binding.pry
    score.scoring_row_set.scored_rows.each_pair do |name, scored_row|
      # a row poses a threat of loss if opponent has two marks and self has none
      if scored_row.data[:u_count] == 2 && scored_row.data[:c_count] == 0# requires immediate block
        # binding.pry
        scored_row.data[:row_marks].each_pair do |k, square|
          if square != 'U'
            a_play = square
            # binding.pry
          end
        end
      end
      #binding.pry
      break if a_play != nil
    end # enod of score.scoring_row_set.each do
    #binding.pry
    a_play
  end

  def blocking_move(score)
    can_lose?(score)
  end

  #scoring_row_set.scored_rows.each_pair do |name, scored_row|
  def can_add_to_row?(score) # will return true on first encountered row that fits condition
    row_to_build = false
    score.scoring_row_set.scored_rows.each_pair do |name, scored_row|
      #binding.pry
      if scored_row.data[:u_count] == 0 && scored_row.data[:c_count] == 1
        row_to_build = true
      end
    end
    #binding.pry
    row_to_build
  end 

  def building_move(score, board)  # must review all scored_rows for best move
    # gather best rows to build on
    a_play = nil

    rows_to_block = {}
    rows_with_user_mark = {}
    coincident_user_marked_squares = []

    candidate_rows = {}
    rows_with_opponent_mark = {}
    opponent_marked_squares = ['C']
    candidate_squares = []

    score.scoring_row_set.scored_rows.each_pair do |name, scored_row|
      if scored_row.data[:u_count] == 0 && scored_row.data[:c_count] == 1
        candidate_rows.store(name, scored_row)
      end

      if scored_row.data[:u_count] == 1 && scored_row.data[:c_count] == 0
        rows_to_block.store(name, scored_row)
      end
    end

    rows_to_block.each_pair do |name, scored_row|
      rows_with_user_mark.store(name, scored_row.data[:row_marks].values)
    end

    row_names = rows_with_user_mark.keys

    first_row_name = row_names[0]
    first_marked_row = rows_with_user_mark.delete(first_row_name)

    rows_with_user_mark.each_pair do |name, marks_array|
      coincident_user_marked_squares = first_marked_row & marks_array
    end

    coincident_user_marked_squares.delete('U')

    candidate_rows.each_pair do |name, scored_row|
      rows_with_opponent_mark.store(name, scored_row.data[:row_marks].values)
    end

    rows_with_opponent_mark.each_pair do |name, marks_array|
      opponent_marked_squares = opponent_marked_squares.union(marks_array)
    end

    opponent_marked_squares.delete('C')
    candidate_squares = opponent_marked_squares & coincident_user_marked_squares

    if candidate_squares.length > 0
      # binding.pry
      a_play = candidate_squares.sample
    else
      # binding.pry
      a_play = opponent_marked_squares.sample
    end
  end

  def valid_play?(a_play, available_squares)
    available_squares.include?(a_play) ? true : false
  end

  def consume_play(a_play, available_squares)
    available_squares.delete(a_play)
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
  #attr_reader :current_score, :won_set, :draw_sets, :in_play_sets, :near_win_sets, :near_loss_sets
  attr_accessor :scoring_row_set, :current_score, :final

  def initialize
    @scoring_row_set = ScorableRows.new
    @current_score = "active"
    @final = nil
  end

  def reset
    initialize
  end
  # called LN: 68 @score.update_score(@current_play, current_player)
  def eval_this_play(this_play, player)
    update_row_stats(this_play, player) #, scoring_row_set)
    score_row_stats(player)
  end

  def report
    puts "     #*#<>  The final score: #{@final}  <>#*#"
  end

  #private
  protected
  def update_row_stats(this_play, player) #, scoring_row_set)
    scoring_row_set.scored_rows.each_pair do |name, scored_row|
      #binding.pry
      scored_row.data[:row_marks].each_pair do |key, value|

        if this_play == key.to_s
          scored_row.data[:row_marks][key] = player.marker
          
          player.marker == 'U' ? scored_row.data[:u_count] += 1 : scored_row.data[:c_count] += 1
          scored_row.data[:row_state] = "in_play"
        end
      end # close inner loop keyed on this_scored_row[key]
    end # close outer loop keyed on name
    #binding.pry
  end

  def score_row_stats(player)
    player_mark = player.marker
    rival_mark = player.rival_mark
    draw_rows_count = 0

    scoring_row_set.scored_rows.each_pair do |name, scored_row|
      #binding.pry
      player_mark_count = (player_mark == 'U' ? scored_row.data[:u_count] : scored_row.data[:c_count])
      rival_mark_count = (rival_mark == 'U' ? scored_row.data[:u_count] : scored_row.data[:c_count])

      case player_mark_count
      when 3
        scored_row.data[:row_state] = "end"
        scored_row.data[:status_msg] = "Game Won by #{player.type}"
        @final = scored_row.data[:status_msg]
        @current_score = 'game over'
      when 2
        scored_row.data[:row_state] = "near_end"
        @current_score = 'active'
      when 1
        scored_row.data[:row_state] = "in play"
        scored_row.data[:status_msg] = "Game play made by #{player.type}"
        @current_score = 'active'
      end
      
      break if @current_score == "game over"

      if (@current_score == 'active') && (player_mark_count + rival_mark_count == 3)

        scored_row.data[:row_state] = 'draw'
        scored_row.data[:status_msg] = "Game tied in this row."
        draw_rows_count += 1
      end
    end # end scoring_row_set.scored_rows.each_pair do

    if draw_rows_count == 8
      @current_score = 'game over'
      @final = "Game ends in a draw ..."
    end
  end
end

class ScorableRows
  attr_accessor :scored_rows

  def initialize
    scored_row_names = ["123", "456", "789", "147", "258", "369", "159", "753"].freeze
    @scored_rows = {}


    scored_row_names.each do |name|
      row_marks = {}  #scored_row = [[row_index].to_sym, [row_index]].to_h
      row_index = name.split(//)
      
      a_scored_row = ScoreRow.new
      # binding.pry
      row_index.each do |i|
        row_marks.store(i.to_sym, i)
      end

      a_scored_row.data[:row_marks] = row_marks
      a_scored_row.data[:row_state] = "new"
      @scored_rows[name.to_s] = a_scored_row
      #binding.pry
    end
    #binding.pry
  end

  def update_row(row_name, marker, index)
    puts "update win set? coming soon!"
  end
end

class ScoreRow
  attr_accessor :data
  def initialize
    @data  = {row_marks: nil, row_state: nil, status_msg: nil, u_count: 0, c_count: 0}
  end
end

g = Game.new

















































