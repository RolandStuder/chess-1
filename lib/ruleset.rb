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
      moves.reduce(&:+).delete_if(&:empty?).size.positive?
    end
  end

  def can_move?(start, dest)
    grid = @board.refine_grid
    location = start.location
    moves = start.piece.next_moves(location, grid)
    if start.piece.is_a? Pawn
      attacks = start.piece.attack_able?(grid, moves[1]) unless moves[1].empty?
      moves = (moves[0] + attacks).compact
    else
      moves.reduce(&:+).delete_if(&:empty?).size.positive?
    end
    moves.include?(dest.location)
  end

  def in_check?
    all_moves = get_possible_moves(@cur_player.color, @board.grid, @board.refine_grid)
    tile = find_king
    return false if all_moves.empty? 

    all_moves.include?(tile.location)
  end

  def find_king
    @board.grid.each do |cell|
      return cell if cell.piece.is_a?(King) && cell.piece.color == @cur_player.color
    end
  end

  def get_possible_moves(color, grid, board)
    move_set = []
    grid.each do |cell|
      next if cell.piece.nil? || cell.piece.color == color

      moves = cell.piece.next_moves(cell.location, board)
      moves = [cell.piece.attack_able?(grid, moves[1]).compact] if cell.piece.is_a? Pawn
      move_set << moves
    end
    return [] if move_set.empty?

    move_set.delete_if(&:empty?)
    move_set.flatten(1).reduce(&:+)
  end

  def trim_king_moves(moveset)
    update_dummy
    refined = []
    current_loc = find_king.location
    moves = moveset.reduce(&:+)
    moves.each do |move|
      @board.mark_grid(current_loc, move)
      refined << move unless in_check?
      clone_dummy
    end
    refined
  end

  def trim_piece_moves(moveset, location)
    refined = []
    moveset.each do |moves|
      #binding.pry
      refined << moves if trim_p_helper(location, moves)
      clone_dummy
    end
    refined
  end

  def trim_p_helper(location, moves)
    update_dummy
    moves.each do |move|
      @board.mark_grid(location, move)
      return false if in_check?

      clone_dummy
    end
    true
  end

  def trim_in_check(moveset)
    
  end
end
