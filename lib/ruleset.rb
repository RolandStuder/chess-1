module Ruleset
  def not_empty?(tile)
    !tile.piece.nil?
  end

  def belongs_to?(tile)
    tile.piece.color == @cur_player.color
  end

  def has_moves?(tile)
    grid = @board.refine_grid
    location = tile.location
    moves = tile.piece.next_moves(location, grid)
    p moves
    moves.size.positive?
  end

  def can_move?(start,dest)
    grid = @board.refine_grid
    dest_location = dest.location
    location = start.location
    moves = start.piece.next_moves(location,grid)
    moves.include?(dest_location)
  end

  def in_check?(tile)
    all_moves = get_possible_moves
  end

  def get_possible_moves(color,grid,board)
    move_set = []
    grid.each do |cell|
       if !cell.piece.nil? && cell.piece.color != color
        moves = cell.piece.next_moves(cell.location,board)
        move_set << moves
       end
    end
    move_set
  end
end
