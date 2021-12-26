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

  def upgrade_possible?
    return unless @driver.can_upgrade?

    input = disp_upgrade
    @driver.upgrade(input)
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
    @driver.init_board
    make_players
    display
    loop do
      upgrade_possible?
      @driver.update_turn
      if @driver.win?
        display
        disp_winner(@driver.winner)
        break
      elsif @driver.draw?
        display
        disp_draw
        break
      end
      send_inputs
      display
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
