require_relative 'cell'
require_relative 'pieces'
require_relative 'an_encoder'
require 'pry-byebug'
class Board
  include Encoder
  attr_reader :grid

  def initialize
    @grid = []
  end

  def create_new_board
    fen = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq'
    fen_decode(fen)
  end

  def refine_grid
    refined_grid = []
    @grid.each do |x|
      refined_grid << (x.piece.nil? ? x.location : x.location + [x.piece.color[0] + x.piece.class.to_s.downcase])
    end
    refined_grid
  end

  def filter_mark(cell1, cell2)
    cells = get_cells(cell1, cell2)
    if rook_and_king?(cells)
      rook_castle(cells[0].location, cells[1].location)
    elsif king_and_castle?(cells)
      king_castle(cells[0].location, cells[1].location)
    elsif pawn_and_en_passant?(cells)
      en_passant(cells[0], cells[0].location, cells[1].location)
    else
      mark_grid(cell1, cell2)
    end
  end

  def rook_and_king?(cells)
    cells[0].piece.is_a?(Rook) && cells[1].piece.is_a?(King)
  end

  def king_and_castle?(cells)
    cells[0].piece.is_a?(King) && (cells[0].location[1] - cells[1].location[1]).abs > 1
  end

  def pawn_and_en_passant?(cells)
    cells[0].piece.is_a?(Pawn) &&
      cells[1].location[1] != cells[0].location[1] &&
      cells[1].empty?
  end

  def mark_grid(cell1, cell2)
    cells = get_cells(cell1, cell2)
    piece = cells[0].piece
    cells[0].piece = nil
    cells[1].piece = piece
  end

  KING_TILES = { 1 => [0, -2], 8 => [0, 2] }.freeze
  def rook_castle(cell1, cell2)
    increment = KING_TILES[cell1[1]]
    new_king_location = [cell2[0] + increment[0], cell2[1] + increment[1]]
    mark_grid(cell2, new_king_location)
    mark_grid(cell1, cell2)
  end

  def king_castle(cell1, cell2)
    rook = if cell1[1] > cell2[1]
             [cell1[0], 1]
           else
             [cell1[0], 8]
           end
    mark_grid(cell1, cell2)
    mark_grid(rook, cell1)
  end

  def en_passant(tile, cell1, cell2)
    remove = tile.color == 'white' ? [cell2[0] - 1, cell2[1]] : [cell2[0] + 1, cell2[1]]
    mark_grid(cell1, cell2)
    mark_grid(cell1, remove)
  end

  def find_cell(cell)
    node = @grid.find { |x| x.location == cell || x.position == cell }
    @grid.index(node)
  end

  def get_cells(cell1, cell2)
    [@grid[find_cell(cell1)], @grid[find_cell(cell2)]]
  end

  def restore_board(fen)
    fen_decode(fen)
  end

  def cloner(dummy)
    @grid = dummy.map(&:clone)
  end

  def update_moved(tile)
    node = @grid[find_cell(tile)]
    node.piece.has_moved
  end

  def replace_piece(tile, new_p, color)
    piece = KEYS[new_p.to_sym].new(color)
    tile.piece = piece
  end
end
