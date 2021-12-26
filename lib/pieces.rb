require_relative 'helper'

class Pieces
  attr_accessor :test_board
  attr_reader :color, :starting

  def initialize(color = nil)
    @color = color
    @starting = true
    @test_board = []
  end

  def make_test_board
    (1..8).each do |i|
      (1..8).each do |j|
        @test_board << [i, j]
      end
    end
  end

  def has_moved
    @starting = false
  end
end

class Knight < Pieces
  include Helper
  MOVES = [[1, 2], [2, 1], [-1, 2], [-2, 1], [2, -1], [1, -2], [-1, -2], [-2, -1]]
  def set_valid(start, board, increment)
    set = super
    [set[0]]
  end
end

class Rook < Pieces
  include Helper

  MOVES = [[-1, 0], [1, 0], [0, 1], [0, -1]]
end

class Bishop < Pieces
  include Helper
  MOVES = [[1, 1], [-1, 1], [-1, -1], [1, -1]]
end

class Queen < Pieces
  include Helper
  MOVES = [[1, 1], [-1, 1], [-1, -1], [1, -1], [-1, 0], [1, 0], [0, 1], [0, -1]]
end

class Pawn < Pieces
  include Helper
  MOVES = { 'black' => [-1, 0], 'white' => [1, 0] }.freeze
  ATTACKS = { 'white' => [[1, -1], [1, 1]], 'black' => [[-1, -1], [-1, 1]] }.freeze

  def all_moves(location, board)
    moves = set_valid(location, board, MOVES[@color])
    attacks = []
    ATTACKS[@color].each { |x| attacks << set_valid(location, board, x)[0] }
    moves.keep_if { |x| x.all? { |y| y.between?(1, 8) } }
    attacks.keep_if { |x| x.all? { |y| y.between?(1, 8) } }
    [moves.compact, attacks.compact]
  end

  def set_valid(start, board, increment)
    set = super
    return [set[0], set[1]] if @starting == true && set.size > 1

    [set[0]]
  end

  def next_moves(location, board)
    moves = all_moves(location, board)
    attacks = refine_attacks(moves[1], board)
    moves[0].pop unless board.include?(moves[0][-1])
    [moves[0], attacks]
  end

  def refine_attacks(attacks, board)
    refined = []
    attacks.each do |attack|
      board.each do |tile|
        refined << attack if attack == tile[0..1] && tile.size == 3 && tile[2][0] != @color[0]
      end
    end
    refined
  end
end

class King < Pieces
  include Helper

  MOVES = [[1, 1], [-1, 1], [-1, -1], [1, -1], [-1, 0], [1, 0], [0, 1], [0, -1]].freeze
  def set_valid(start, board, increment)
    set = super
    [set[0]]
  end
end
