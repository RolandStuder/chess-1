require 'pry-byebug'
module Helper
  def next_moves(location, board)
    legal_moves = []
    self.class::MOVES.each do |x|
      set = set_valid(location, board, x)
      set.pop unless set[-1].all? { |y| y.between?(1, 8) } && attack_able?(set[-1], board)
      legal_moves << set.compact unless set.empty?
    end
    legal_moves.compact
  end

  def set_valid(start, board, increment)
    set = []
    set << start
    loop do
      set << [set[-1][0] + increment[0], set[-1][1] + increment[1]]
      break unless board.include?(set[-1])
    end

    set.shift
    set
  end

  def attack_able?(tile, board)
    board.each do |x|
      next unless x[0..1] == tile
      return true if x.size == 2

      return x[2][0] != @color[0]
    end
  end
end
