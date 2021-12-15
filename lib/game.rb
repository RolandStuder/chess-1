require_relative 'display'
require_relative 'driver'

class Game
  include Display
  def initialize
    @player1 = nil
    @player2 = nil
    @driver = Driver.new
    @id = nil
  end

  def get_grid
    @driver.send_grid
  end

  def make_board
    @driver.init_board
  end

  def send_input
    input1 = get_input
    input2 = get_input
    @driver.receive_input(input1, input2)
  end

  def display
    grid = get_grid
    display_grid(grid)
  end

  def play
    make_board
    display
    3.times do
      send_input
      display
    end
  end
end

Game.new.play
