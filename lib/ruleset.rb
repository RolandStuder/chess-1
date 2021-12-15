module Ruleset
  def not_empty?(tile)
    !tile.piece.nil?
  end

  def belongs_to?(tile)
    tile.piece.color == 'black'
  end

  def has_moves?(tile)
    grid = @board.refine_grid
    location = tile.location
    moves = tile.piece.next_moves(location, grid)
    moves.size > 0
  end
end
