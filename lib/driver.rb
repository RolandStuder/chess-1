require_relative 'pieces'
require_relative 'board'
require_relative 'player'
require_relative 'cell'
require_relative 'ruleset'
require 'pry-byebug'
class Driver
  include Ruleset
  attr_reader :board

  def initialize
    @board = Board.new
    @player1 = nil
    @player2 = nil
    @cur_player = nil
    @dummy_board = nil
  end

  def init_board
    @board.create_new_board
  end

  def receive_input(input1, input2)
    @board.mark_grid(input1, input2)
  end

  def send_grid
    @board.refine_grid
  end

  def selection_valid?(tile)
    node = @board.grid[@board.find_cell(tile)]
    not_empty?(node) &&
      belongs_to?(node) &&
      has_moves?(node)
  end

  def move_legal?(start, dest)
    node1 = @board[@board.find_cell(start)]
    node2 = @board[@board.find_cell(dest)]
    can_move?(node1, node2)
  end

  def set_players(p1, p2 = nil)
    @player1 = Human.new(p1, 'white')
    if p2
      @player2 = Human.new(p1, 'black')
    else
      @player1 = Bot.new('Computer', 'black')
    end
    @cur_player = @player1
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
end

driver = Driver.new
driver.board.restore_board('8/8/8/3K4/2Q5/8/b7/8')
driver.set_players('', '')
moves = driver.board.grid[34].piece.next_moves([4, 3], driver.board.refine_grid)
p driver.trim_piece_moves(moves,[4,3])
#driver.trim_p_helper([4,4],moves[4])
# p driver.selection_valid?('a1')
