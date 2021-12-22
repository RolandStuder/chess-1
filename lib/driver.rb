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
driver.board.restore_board('K7/8/8/8/8/8/2b1P3/3R4')
driver.set_players('', '')
p driver.get_moves(driver.board.grid[59]).reduce(&:+)

# p driver.selection_valid?('a1')e-21xx1
