require_relative 'ruleset'

module Smoves
  include Ruleset

  ROOK_TILES = { 1 => [0, 1], 8 => [0, -1] }.freeze
  KING_TILES = { 8 => [0, 1], 1 => [0, -1] }.freeze

  def allow_castle(type)
    rooks = possible_castles(@board.grid)
    return [] if rooks.empty?

    if type == 'king'
      rooks.map { |x| get_moveset(KING_TILES[x.location[1]])[-1] }
    elsif rooks.map(&:location).include?(type)
      [[find_king.location]]
    else
      []
    end
  end

  def possible_castles(grid)
    set = r_and_k_at_start(grid)
    return [] if in_check?
    return [] unless r_and_k_available?(set)

    rooks = check_empty_tiles(set)
    return [] if rooks.empty?

    squares_safe?(rooks)
  end

  def r_and_k_at_start(grid)
    grid.select { |tile| !tile.empty? && tile.color == @cur_player.color }
        .select { |tile| tile.piece.starting == true }
        .select { |x| x.piece.is_a?(King) || x.piece.is_a?(Rook) }
  end

  def r_and_k_available?(set)
    return false if set.size < 2

    set.any? { |x| x.piece.is_a? King } &&
      set.any? { |x| x.piece.is_a? Rook }
  end

  def check_empty_tiles(set)
    rooks =  set.select { |x| x.piece.is_a? Rook }
    refined = []
    rooks.each do |rook|
      increment = ROOK_TILES[rook.location[1]]
      refined << rook if has_empty_tiles?(rook, increment)
    end
    refined
  end

  def has_empty_tiles?(rook, increment)
    tiles = [rook.location]
    tiles << [tiles[-1][0] + increment[0], tiles[-1][1] + increment[1]] until tiles[-1][1] == 5
    tiles[1..-2].all? { |x| @board.grid[@board.find_cell(x)].empty? }
  end

  def squares_safe?(rooks)
    refined = []
    rooks.each do |rook|
      increment = KING_TILES[rook.location[1]]
      moveset = get_moveset(increment)
      refined << rook if moveset.size == trim_king_moves(moveset).size
    end
    refined
  end

  def get_moveset(increment)
    moveset = [find_king.location]
    2.times { moveset << [moveset[-1][0] + increment[0], moveset[-1][1] + increment[1]] }
    moveset[1..-1].map { |x| [x] }
  end
end
