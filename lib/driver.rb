require_relative 'pieces'
require_relative 'board'
require_relative 'player'
require_relative 'cell'
require_relative 'ruleset'
require_relative 'special_moves'
require 'pry-byebug'

class Driver
  include Ruleset
  include Smoves
  attr_reader :board

  def initialize
    @board = Board.new
    @player1 = nil
    @player2 = nil
    @cur_player = nil
    @dummy_board = nil
    @last_move = 'd7 d5'
  end

  def init_board
    @board.create_new_board
  end

  def receive_input(input1, input2)
    update_last_move(input1, input2)
    @board.update_moved(input1)
    @board.filter_mark(input1, input2)
  end

  def send_grid
    @board.refine_grid
  end

  def selection_valid?(tile)
    return false unless valid?(tile)

    node = @board.grid[@board.find_cell(tile)]
    not_empty?(node) &&
      belongs_to?(node) &&
      movable?(node)
  end

  def move_legal?(start, dest)
    return false unless valid?(dest)

    start = @board.grid[@board.find_cell(start)]
    dest = @board.grid[@board.find_cell(dest)].location
    can_move?(dest, start)
  end

  def set_players(p1, p2 = nil)
    @player1 = Human.new(p1, 'white')
    @player2 = if p2
                 Human.new(p2, 'black')
               else
                 Bot.new('Computer', 'black')
               end
    @cur_player = @player2
  end

  def update_turn
    @cur_player = @cur_player == @player1 ? @player2 : @player1
  end

  def update_dummy
    @dummy_board = @board.grid.map(&:clone)
  end

  def clone_dummy
    @board.cloner(@dummy_board)
  end

  def select_piece
    input = @cur_player.piece_select
    until selection_valid?(input)
      puts 'The selected tile does not exist or is invalid or has no legal moves' if @cur_player.is_a? Human
      input = @cur_player.piece_select
    end
    input
  end

  def select_move(input)
    move = @cur_player.move_select
    until move_legal?(input, move)
      puts 'This is not a legal move! Please try again!' if @cur_player.is_a? Human
      move = @cur_player.move_select
    end
    move
  end

  def update_last_move(last, n_move)
    @last_move = "#{last} #{n_move}"
  end

  def check_upgrade
    @board.grid.select { |pawn| pawn.piece.is_a?(Pawn) && [1, 8].include?(pawn.location[0]) }
  end

  def can_upgrade?
    !check_upgrade.empty?
  end

  def upgrade(n_piece)
    @board.replace_piece(check_upgrade[0], n_piece, @cur_player.color)
  end

  def winner
    update_turn.name
  end
end
