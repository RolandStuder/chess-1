require_relative 'cell'
require_relative 'pieces'
require_relative 'an_encoder'

class Board
  include Encoder
  attr_reader :grid

  def initialize
    @grid = []
  end

  def create_new_board
    fen = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR'
    refined_notation = refine_notation(fen)
    return 'bad notation' unless verify_notation(refined_notation)

    fen_to_board(refined_notation)
  end

  def refine_grid
    refined_grid = []
    @grid.each do |x|
      refined_grid << (x.piece.nil? ? x.location : x.location + [x.piece.color[0] + x.piece.class.to_s.downcase])
    end
    refined_grid
  end

  def mark_grid(cell1, cell2)
    pre_cell = find_cell(cell1)
    nex_cell = find_cell(cell2)
    piece = @grid[pre_cell].piece
    @grid[pre_cell].piece = nil
    @grid[nex_cell].piece = piece
  end

  def find_cell(cell)
    node = @grid.find { |x| x.location == cell || x.position == cell }
    @grid.index(node)
  end

  def restore_board(fen)
    refined_notation = refine_notation(fen)
    return 'Bad input' unless verify_notation(refined_notation)

    fen_to_board(refined_notation)
  end

  def cloner(dummy)
    @grid = dummy.map(&:clone)
  end
end

# board = Board.new
# board.create_new_board
# p board.find_cell([1,1])
