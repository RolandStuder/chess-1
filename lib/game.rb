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

  def send_input
    input1 = get_input
    until @driver.selection_valid?(input1)
      puts 'wrong lol'
      input1 = get_input
    end
    input2 = get_input
    input2 = get_input until @driver.move_legal?(input1, input2)
    @driver.receive_input(input1, input2)
  end

  def display
    grid = get_grid
    display_grid(grid)
  end

  def play
    make_board
    make_players
    display
    3.times do
      send_input
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
