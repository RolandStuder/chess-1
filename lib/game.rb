require_relative 'display'
require_relative 'driver'

class Game
  include Display
  def initialize
    @driver = Driver.new
    @id = nil
  end

  def get_grid
    @driver.send_grid
  end

  def make_board
    @driver.init_board
  end

  def call_inputs
    input1 = @driver.select_piece
    input2 = @driver.select_move(input1)
    [input1, input2]
  end

  def display
    grid = get_grid
    display_grid(grid)
  end

  def send_inputs
    inputs = call_inputs
    @driver.receive_input(inputs[0], inputs[1])
  end

  def play
    @driver.board.restore_board('r3k2r/8/8/8/8/4P3/8/R3K2R')
    make_players
    display
    loop do
      send_inputs
      display
      @driver.update_turn
    end
  end

  def make_players
    input = bot_pvp?
    p1 = get_names('Player 1')
    if input == '1'
      p2 = get_names('Player 2')
      @driver.set_players(p1, p2)
    else
      @driver.set_players(p1)
    end
  end
end

Game.new.play
