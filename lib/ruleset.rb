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
    if tile.piece.is_a? Pawn
      attacks = tile.piece.attack_able?(grid, moves[1]) unless moves[1].empty?
      (moves[0] + attacks).compact.size.positive?
    else
      moves.size.positive?
    end
  end

  def can_move?(start, dest)
    grid = @board.refine_grid
    location = start.location
    moves = start.piece.next_moves(location, grid)
    if start.piece.is_a? Pawn
      attacks = start.piece.attack_able?(grid, moves[1]) unless moves[1].empty?
      moves = (moves[0] + attacks).compact
    end
    moves.include?(dest.location)
  end

  def in_check?(board)
    all_moves = get_possible_moves(@cur_player.color,@board.grid,@board.refine_grid)
    tile = find_king(board)
    all_moves.include?(tile.location)
  end

  def find_king(board)
    board.each do |cell|
      return cell if cell.piece.is_a?(King) && cell.piece.color == @cur_player.color
    end
  end

  def get_possible_moves(color, grid, board)
    move_set = []
    grid.each do |cell|
      next if cell.piece.nil? || cell.piece.color == color

      moves = cell.piece.next_moves(cell.location, board)
      moves = cell.piece.attack_able?(grid,moves[1]).compact if cell.piece.is_a? Pawn
      move_set << moves
    end
    move_set.delete_if(&:empty?)
    move_set.reduce(&:+)
  end
end
