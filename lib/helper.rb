module Helper
  def next_moves(location, board)
    legal_moves = []
    self.class::MOVES.each do |x|
      set = set_valid(location, board, x)
      set.each { |y| legal_moves << y }
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

    set.pop unless set[-1].all? { |x| x.between?(1, 8) }
    set.shift
    set
  end
end
