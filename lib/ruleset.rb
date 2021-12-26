module Ruleset
  def valid?(selection)
    selection.size == 2 &&
      selection[0].between?('a', 'h') &&
      selection[1].between?('1', '8')
  end

  def not_empty?(tile)
    !tile.empty?
  end

  def belongs_to?(tile)
    tile.color == @cur_player.color
  end

  def movable?(tile)
    moves = get_moves(tile)
    return false if moves.empty?

    moves.reduce(&:+).size.positive?
  end

  def can_move?(location, tile)
    moves = get_moves(tile)
    moves.reduce(&:+).include?(location)
  end

  def in_check?
    all_moves = get_possible_moves(@board.grid, @board.refine_grid)
    tile = find_king
    return false if all_moves.nil?

    all_moves.include?(tile.location)
  end

  def find_king
    @board.grid.select { |cell| cell.piece.is_a?(King) && cell.color == @cur_player.color }[0]
  end

  def get_possible_moves(grid, board)
    get_opponent_pieces(grid).map do |cell|
      cell.piece.is_a?(Pawn) ? [cell.call_moves(board)[1]] : cell.call_moves(board)
    end.delete_if(&:empty?).flatten(1).reduce(&:+)
  end

  def get_opponent_pieces(grid)
    grid.select { |cell| !cell.piece.nil? && cell.piece.color != @cur_player.color }
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
    moves = tile.call_moves(@board.refine_grid)
    if tile.piece.is_a? King
      trim_king_moves(moves) + allow_castle('king')
    elsif tile.piece.is_a?(Rook) && !in_check?
      trim_piece_moves(moves, location) + allow_castle(location)
    elsif in_check?
      [trim_in_check(moves, location)]
    else
      trim_piece_moves(moves, location)
    end
  end
end
