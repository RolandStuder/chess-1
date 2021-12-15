require_relative 'pieces'
require_relative 'board'
require_relative 'player'
require_relative 'cell'
require_relative 'ruleset'
require 'pry-byebug'
class Driver
  include Ruleset
  def initialize
    @board = Board.new
    @type = 'PvP'
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
    p node
    not_empty?(node) &&
      belongs_to?(node) &&
      has_moves?(node)
  end

  def move_legal?(tile)
    node = @board[@board.find_cell(tile)]
    can_move?(node) &&
      can_attack?(node) &&
      king_check?(node)
  end
end

driver = Driver.new
driver.init_board
p driver.selection_valid?('e7')
# p driver.selection_valid?('a1')
