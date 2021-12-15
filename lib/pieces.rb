require_relative 'helper'

class Pieces
  attr_accessor :test_board
  attr_reader :color

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
end

class Knight < Pieces
  MOVES = [[1, 2], [2, 1], [-1, 2], [-2, 1], [2, -1], [1, -2], [-1, -2], [-2, -1]]
  def next_moves(point)
    set = MOVES.map { |x| [x[0] + point[0], x[1] + point[1]] }
    set.keep_if { |x| x[0].between?(1, 8) && x[1].between?(1, 8) }
    set
  end
end

class Rook < Pieces
  include Helper
  def moved?
    @starting = false
  end

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
  def moved?
    @starting = false
  end
  MOVES = [[1, 0], [-1, 0]]

  def set_valid(start, board, increment)
    set = super
    return [set[0], set[1]] if @starting == true && set.size > 1

    [set[0]]
  end
end

class King < Pieces
  include Helper
  def moved?
    @starting = false
  end

  MOVES = [[1, 1], [-1, 1], [-1, -1], [1, -1], [-1, 0], [1, 0], [0, 1], [0, -1]]
  def set_valid(start, board, increment)
    set = super
    [set[0]]
  end
end
