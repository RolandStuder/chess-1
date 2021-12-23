module Ruleset
  def valid?(selection)
    selection.size == 2 &&
      selection[0].between?('a', 'h') &&
      selection[1].between?('1', '8')
  end

  def not_empty?(tile)
    !tile.piece.nil?
  end

  def belongs_to?(tile)
    tile.piece.color == @cur_player.color
  end

  def has_moves?(tile)
    moves = get_moves(tile)
    return false if moves.empty?

    moves.reduce(&:+).size.positive?
  end

  def can_move?(location, tile)
    moves = get_moves(tile)
    moves.reduce(&:+).include?(location)
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
      moves = [cell.piece.all_moves(cell.location, board)[1]] if cell.piece.is_a? Pawn
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
      refined << [move] unless in_check?
      clone_dummy
    end
    refined
  end

  def trim_piece_moves(moveset, location)
    update_dummy
    refined = []
    moveset.each do |moves|
      clone_dummy
      refined << moves if trim_p_helper(location, moves)
    end
    clone_dummy
    refined
  end

  def trim_p_helper(location, moves)
    moves.each do |move|
      @board.mark_grid(location, move)
      return false if in_check?
    end
    true
  end

  def trim_in_check(moveset, location)
    update_dummy
    moves = moveset.flatten(1)
    refined = []
    moves.each do |move|
      @board.mark_grid(location, move)
      refined << move unless in_check?
      clone_dummy
    end
    refined
  end

  def get_moves(tile)
    location = tile.location
    moves = tile.piece.next_moves(location, @board.refine_grid)
    if tile.piece.is_a? King
      trim_king_moves(moves)
    elsif in_check?
      [trim_in_check(moves, location)]
    else
      trim_piece_moves(moves, location)
    end
  end
end
