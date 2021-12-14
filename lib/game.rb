require_relative 'board'
require_relative 'display'

class Game
  include Display
  def initialize
    @player1 = nil
    @player2 = nil
    @board = Board.new
    @id = nil
  end
=begin
  def play
    welcome
    if new_game?
      create_board
      populate_board
      create_players
    else
      restore_game
    end

    display_board
    get_input
    update_board
    if checkmate?
      decide_winner
      announce_winner
      break
    elsif draw?
      announce_draw
      break
    end
    update_id
  end
=end

def disp
  @board.create_new_board
  grid = @board.refine_grid
  display_grid(grid)
end

end

Game.new.disp