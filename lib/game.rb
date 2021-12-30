require_relative 'display'
require_relative 'driver'
require_relative 'loader'

class Game
  include Display
  include Loader
  def initialize
    @driver = Logic.new
    @id = generate_id
  end

  def generate_id
    Array.new(5).map{rand(1..9)}.join
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
    make_players
  end

  def call_inputs
    input1 = @driver.select_piece
    display(@driver.send_moves(input1))
    input2 = @driver.select_move(input1)
    [input1, input2]
  end

  def display(moves = [])
    grid = get_grid
    display_grid(grid, moves)
  end

  def send_inputs
    inputs = call_inputs
    @driver.receive_input(inputs[0], inputs[1])
  end

  def game_type
    input = type_input
    input == '1' ? make_board : load_game
  end

  def play
    game_type
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
      save?
    end
  end

  def save?
    input = disp_save
    save if input == '1'
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
