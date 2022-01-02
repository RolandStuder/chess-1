require_relative '../lib/driver'

RSpec.describe Logic do
  # decribe '' do
  #  context '' do
  #    subject(:) {described_class.new}
  #  end
  # end

  describe '#valid?' do
    context 'should check for a valid entry' do
      subject(:v_check) { described_class.new }

      it 'Returns false for invalid input' do
        expect(v_check.valid?('8a')).to be_falsy
      end

      it 'Returns false for invalid input' do
        expect(v_check.valid?('a9')).to be_falsy
      end

      it 'Returns false for invalid input' do
        expect(v_check.valid?('i6')).to be_falsy
      end

      it 'Returns true for valid input' do
        expect(v_check.valid?('a7')).to be_truthy
      end

      it 'Returns true for valid input' do
        expect(v_check.valid?('h8')).to be_truthy
      end
    end
  end

  describe '#not_empty?' do
    context 'should return true if the tile is not empty' do
      subject(:e_check) { described_class.new }
      before do
        e_check.init_board
      end

      it 'Returns false for invalid input' do
        expect(e_check.not_empty?(e_check.board.grid[16])).to be_falsy
      end

      it 'Returns false for invalid input' do
        expect(e_check.not_empty?(e_check.board.grid[25])).to be_falsy
      end

      it 'Returns false for invalid input' do
        expect(e_check.not_empty?(e_check.board.grid[38])).to be_falsy
      end

      it 'Returns true for valid input' do
        expect(e_check.not_empty?(e_check.board.grid[0])).to be_truthy
      end

      it 'Returns true for valid input' do
        expect(e_check.not_empty?(e_check.board.grid[63])).to be_truthy
      end
    end
  end

  describe '#belongs_to?' do
    context 'should return true when the tile belongs to current player' do
      subject(:c_check) { described_class.new }
      before do
        c_check.init_board
        c_check.instance_variable_set('@cur_player', Player.new('test', 'white'))
      end

      it 'Returns false for invalid input' do
        expect(c_check.belongs_to?(c_check.board.grid[0])).to be_falsy
      end

      it 'Returns false for invalid input' do
        expect(c_check.belongs_to?(c_check.board.grid[8])).to be_falsy
      end

      it 'Returns false for invalid input' do
        expect(c_check.belongs_to?(c_check.board.grid[15])).to be_falsy
      end

      it 'Returns true for valid input' do
        expect(c_check.belongs_to?(c_check.board.grid[62])).to be_truthy
      end

      it 'Returns true for valid input' do
        expect(c_check.belongs_to?(c_check.board.grid[50])).to be_truthy
      end
    end
  end

  describe '#movable?' do
    context 'Should return true if the piece is movable' do
      subject(:driver) { described_class.new }
      before do
        driver.set_players('', '')
        driver.init_board
      end

      it 'Returns false for invalid input' do
        expect(driver.movable?(driver.board.grid[0])).to be_falsy
      end

      it 'Returns false for invalid input' do
        expect(driver.movable?(driver.board.grid[63])).to be_falsy
      end

      it 'Returns false for invalid input' do
        expect(driver.movable?(driver.board.grid[7])).to be_falsy
      end

      it 'Returns true for valid input' do
        expect(driver.movable?(driver.board.grid[8])).to be_truthy
      end

      it 'Returns true for valid input' do
        expect(driver.movable?(driver.board.grid[57])).to be_truthy
      end
    end
  end

  describe '#in_check?' do
    context 'It should return true if the king is in check' do
      subject(:king) { described_class.new }
      before do
        king.instance_variable_set('@cur_player', Player.new('', 'white'))
      end

      it 'returns true if the king is in check' do
        king.board.restore_board('3rk2r/8/8/3K4/7R/8/8/R7 w - - 0 1')
        expect(king.in_check?).to be_truthy
      end

      it 'returns true if the king is in check' do
        king.board.restore_board('3rk2r/8/q7/8/7R/8/8/R4K2 w - - 0 1')
        expect(king.in_check?).to be_truthy
      end

      it 'returns true if the king is in check' do
        king.board.restore_board('8/8/8/8/8/8/6q1/7K w - - 0 1')
        expect(king.in_check?).to be_truthy
      end

      it 'returns false if the king is not in check' do
        king.board.restore_board('3rk2r/8/q7/8/7R/1K6/8/R7 w - - 0 1')
        expect(king.in_check?).to be_falsy
      end

      it 'returns false if the king is not in check' do
        king.board.restore_board('3rk2r/8/q7/8/7R/8/8/R6K w - - 0 1')
        expect(king.in_check?).to be_falsy
      end
    end
  end

  describe '#can_move?' do
    context 'Should return true if the piece can move to the location' do
      subject(:driver) { described_class.new }
      before do
        driver.set_players('', '')
        driver.init_board
      end

      it 'Returns true for valid input' do
        expect(driver.can_move?([6, 1], driver.board.grid[1])).to be_truthy
      end

      it 'Returns true for valid input' do
        expect(driver.can_move?([5, 1], driver.board.grid[8])).to be_truthy
      end

      it 'Returns false for invalid input' do
        expect(driver.can_move?([1, 1], driver.board.grid[7])).to be_falsy
      end

      it 'Returns false for invalid input' do
        expect(driver.can_move?([1, 1], driver.board.grid[8])).to be_falsy
      end

      it 'Returns true for valid input' do
        expect(driver.can_move?([1, 7], driver.board.grid[57])).to be_falsy
      end
    end
  end

  describe '#find_king' do
    context 'It finds the cell of the king and returns it' do
      subject(:king) { described_class.new }
      before do
        king.instance_variable_set('@cur_player', Player.new('', 'white'))
      end

      it 'When the king is at a1' do
        king.board.restore_board('2q5/4n3/Q7/1N1k4/6p1/8/4R1P1/K7 w - - 0 1')
        expect(king.find_king.position).to eql('a1')
      end

      it 'When the king is at e7' do
        king.board.restore_board('2q5/4K3/Q7/1N1k4/6p1/8/4R1P1/8 w - - 0 1')
        expect(king.find_king.position).to eql('e7')
      end

      it 'When the king is at h6' do
        king.board.restore_board('8/8/7K/8/8/8/8/8 w - - 0 1')
        expect(king.find_king.position).to eql('h6')
      end

      it 'When the king is at c8' do
        king.board.restore_board('2K5/8/8/8/8/8/8/8 w - - 0 1')
        expect(king.find_king.position).to eql('c8')
      end

      it 'When the king does not exist' do
        king.board.restore_board('8/8/8/8/8/8/8/8 w - - 0 1')
        expect(king.find_king).to be nil
      end
    end
  end

  describe '#get_possible_moves' do
    context 'It returns all possible moves of the enemy (and attacks of pawns)' do
      subject(:driver) { described_class.new }
      before do
        driver.instance_variable_set('@cur_player', Player.new('', 'white'))
      end

      it 'When there is one black pawn and rook' do
        expected = [[6, 2], [6, 4], [8, 4], [6, 4], [5, 4], [4, 4], [3, 4], [2, 4], [1, 4], [7, 5], [7, 6], [7, 7],
                    [7, 8]].sort
        driver.board.restore_board('8/2pr4/8/8/8/8/8/8 w - - 0 1')
        expect(driver.get_possible_moves(driver.board.grid, driver.board.refine_grid).sort).to eql(expected)
      end

      it 'When there is a black bishop surrounded by white pawns' do
        expected = [[6, 3], [7, 2], [6, 5], [7, 6], [4, 3], [3, 2], [4, 5], [3, 6]].sort
        driver.board.restore_board('8/1P3P2/8/3b4/8/1P3P2/8/8 w - - 0 1')
        expect(driver.get_possible_moves(driver.board.grid, driver.board.refine_grid).sort).to eql(expected)
      end

      it 'When there is a black king' do
        expected = [[4, 3], [4, 4], [4, 5], [6, 3], [6, 4], [6, 5], [5, 3], [5, 5]].sort
        driver.board.restore_board('8/8/8/3k4/8/8/8/8 w - - 0 1')
        expect(driver.get_possible_moves(driver.board.grid, driver.board.refine_grid).sort).to eql(expected)
      end

      it 'When there are black pawns at the end of the board' do
        expected = []
        driver.board.restore_board('8/8/8/8/8/8/8/1p1p1p2 w - - 0 1')
        expect(driver.get_possible_moves(driver.board.grid, driver.board.refine_grid).sort).to eql(expected)
      end

      it 'When there are no black pieces' do
        expected = nil
        driver.board.restore_board('4N3/8/8/3R4/5K2/2Q5/8/8 w - - 0 1')
        expect(driver.get_possible_moves(driver.board.grid, driver.board.refine_grid)).to eql(expected)
      end
    end
  end

  describe '#get_opponent_pieces' do
    context 'It returns all the pieces of the opponent' do
      subject(:driver) { described_class.new }
      before do
        driver.instance_variable_set('@cur_player', Player.new('', 'white'))
      end

      it 'When there are no black pieces' do
        expected = []
        driver.board.restore_board('4N3/8/8/3R4/5K2/2Q5/8/8 w - - 0 1')
        expect(driver.get_opponent_pieces(driver.board.grid)).to eql(expected)
      end

      it 'When there are two pawns' do
        expected = %w[Pawn Pawn]
        driver.board.restore_board('4N3/2p2p2/8/3R4/5K2/2Q5/8/8 w - - 0 1')
        outcome = driver.get_opponent_pieces(driver.board.grid).map { |x| x.piece.class.to_s }
        expect(outcome).to eql(expected)
      end

      it 'When there is a queen and a king' do
        expected = %w[Queen King]
        driver.board.restore_board('8/2q5/8/4k3/8/8/8/8 w - - 0 1')
        outcome = driver.get_opponent_pieces(driver.board.grid).map { |x| x.piece.class.to_s }
        expect(outcome).to eql(expected)
      end

      it 'When there is a knight and a bishop' do
        expected = %w[Bishop Knight]
        driver.board.restore_board('5b2/8/2n5/8/8/8/8/8 w - - 0 1')
        outcome = driver.get_opponent_pieces(driver.board.grid).map { |x| x.piece.class.to_s }
        expect(outcome).to eql(expected)
      end

      it 'When there are 3 kings' do
        expected = %w[King King King]
        driver.board.restore_board('8/2kkk3/8/8/8/8/8/8 w - - 0 1')
        outcome = driver.get_opponent_pieces(driver.board.grid).map { |x| x.piece.class.to_s }
        expect(outcome).to eql(expected)
      end
    end
  end

  describe '#trim_king_moves' do
    context 'It trims the kings moves and avoids illegal moves' do
      subject(:king) { described_class.new }
      before do
        king.instance_variable_set('@cur_player', Player.new('', 'white'))
      end

      it 'When the king is alone in the middle' do
        king.board.restore_board('8/8/8/8/3K4/8/8/8 w - - 0 1')
        moves = king.find_king.call_moves(king.board.refine_grid)
        expect(king.trim_king_moves(moves)).to eql(moves)
      end

      it 'When the king`s left file is under attack' do
        king.board.restore_board('2r5/8/8/8/3K4/8/8/8 w - - 0 1')
        expected = [[[5, 4]], [[5, 5]], [[4, 5]], [[3, 5]], [[3, 4]]].sort
        moves = king.find_king.call_moves(king.board.refine_grid)
        expect(king.trim_king_moves(moves).sort).to eql(expected)
      end

      it 'When both files are under attack' do
        king.board.restore_board('2r1r3/8/8/8/3K4/8/8/8 w - - 0 1')
        expected = [[[5, 4]], [[3, 4]]].sort
        moves = king.find_king.call_moves(king.board.refine_grid)
        expect(king.trim_king_moves(moves).sort).to eql(expected)
      end

      it 'When both files and the bottom rank are under attack by pawns' do
        king.board.restore_board('8/8/1p3p2/1p3p2/1ppKpp2/8/8/8 w - - 0 1')
        expected = [[[5, 4]]].sort
        moves = king.find_king.call_moves(king.board.refine_grid)
        expect(king.trim_king_moves(moves).sort).to eql(expected)
      end

      it 'When the king is surrounded' do
        king.board.restore_board('2r5/8/8/7r/3K4/r7/8/4r3 w - - 0 1')
        expected = []
        moves = king.find_king.call_moves(king.board.refine_grid)
        expect(king.trim_king_moves(moves).sort).to eql(expected)
      end
    end
  end

  describe '#trim_piece_moves' do
    context 'It trims off all moves that might leave the king in check' do
      subject(:piece) { described_class.new }
      before do
        piece.instance_variable_set('@cur_player', Player.new('', 'white'))
      end

      it 'When a bishop in front of the queen is blocking the king' do
        piece.board.restore_board('3q4/8/8/8/8/8/3B4/3K4 w - - 0 1')
        moves = piece.board.grid[51].call_moves(piece.board.refine_grid)
        expected = []
        expect(piece.trim_piece_moves(moves, [2, 4]).sort).to eql(expected)
      end

      it 'When a rook in front of the queen is blocking the king' do
        piece.board.restore_board('8/8/8/8/3q4/8/3R4/3K4 w - - 0 1')
        moves = piece.board.grid[51].call_moves(piece.board.refine_grid)
        expected = [[[3, 4], [4, 4]]]
        expect(piece.trim_piece_moves(moves, [2, 4]).sort).to eql(expected)
      end

      it 'When a Pawn in front of the queen is blocking the king' do
        piece.board.restore_board('3q4/8/8/8/8/8/3P4/3K4 w - - 0 1')
        moves = piece.board.grid[51].call_moves(piece.board.refine_grid)
        expected = [[[3, 4], [4, 4]]]
        expect(piece.trim_piece_moves(moves, [2, 4]).sort).to eql(expected)
      end

      it 'When a Pawn blacks the queen in diagonals' do
        piece.board.restore_board('8/8/8/6q1/8/8/3P4/2K5 w - - 0 1')
        moves = piece.board.grid[51].call_moves(piece.board.refine_grid)
        expected = []
        expect(piece.trim_piece_moves(moves, [2, 4]).sort).to eql(expected)
      end

      it 'When the rook is free to move' do
        piece.board.restore_board('8/8/q7/8/8/8/3R4/2K5 w - - 0 1')
        moves = piece.board.grid[51].call_moves(piece.board.refine_grid)
        expected = moves.sort
        expect(piece.trim_piece_moves(moves, [2, 4]).sort).to eql(expected)
      end
    end
  end

  describe '#trim_piece_helper' do
    context 'It should return true if a move in one direction does not leave the king in check' do
      subject(:piece) { described_class.new }
      before do
        piece.instance_variable_set('@cur_player', Player.new('', 'white'))
      end

      it 'King in check - Bishop moves' do
        piece.board.restore_board('3q4/8/8/8/8/8/3B4/3K4 w - - 0 1')
        moves = [[3, 3], [4, 2], [5, 1]]
        expect(piece.trim_piece_helper([2, 4], moves)).to be_falsy
      end

      it 'King in check, Knight moves' do
        piece.board.restore_board('8/8/8/8/3q4/8/3N4/3K4 w - - 0 1')
        moves = [[4, 3]]
        expect(piece.trim_piece_helper([2, 4], moves)).to be_falsy
      end

      it 'King in check, pawn moves' do
        piece.board.restore_board('3q4/8/8/8/8/2p5/3P4/3K4 w - - 0 1')
        moves = [[3, 3]]
        expect(piece.trim_piece_helper([2, 4], moves)).to be_falsy
      end

      it 'King in check, rook moves but in same direction' do
        piece.board.restore_board('8/8/8/3q4/8/8/3R4/3K4 w - - 0 1')
        moves = [[3, 4], [4, 4], [5, 4]]
        expect(piece.trim_piece_helper([2, 4], moves)).to be_truthy
      end

      it 'pawn moves - King not in check' do
        piece.board.restore_board('8/7q/8/8/8/8/3P4/3K4 w - - 0 1')
        moves = [[3, 4], [4, 4]]
        expect(piece.trim_piece_helper([2, 4], moves)).to be_truthy
      end
    end
  end

  describe '#trim_in_check' do
    context 'It should return the moves a piece can make to save the king in check' do
      subject(:piece) { described_class.new }
      before do
        piece.instance_variable_set('@cur_player', Player.new('', 'white'))
      end

      it 'King in check - Bishop can save' do
        piece.board.restore_board('8/q7/8/8/8/4K3/8/B7 w - - 0 1')
        moves = piece.board.grid[56].call_moves(piece.board.refine_grid)
        expected = [[4, 4]]
        expect(piece.trim_in_check(moves, [1, 1])).to eql(expected)
      end

      it 'King in check, Knight can save' do
        piece.board.restore_board('8/8/4q3/2N5/8/4K3/8/8 w - - 0 1')
        moves = piece.board.grid[26].call_moves(piece.board.refine_grid)
        expected = [[4, 5], [6, 5]].sort
        expect(piece.trim_in_check(moves, [5, 3]).sort).to eql(expected)
      end

      it 'King in check, pawn cannot save' do
        piece.board.restore_board('8/8/4q3/2P5/8/4K3/8/8 w - - 0 1')
        moves = piece.board.grid[26].call_moves(piece.board.refine_grid)
        expected = []
        expect(piece.trim_in_check(moves, [5, 3]).sort).to eql(expected)
      end

      it 'King in check, pawn can save' do
        piece.board.restore_board('8/8/4q3/3P4/8/4K3/8/8 w - - 0 1')
        moves = piece.board.grid[27].call_moves(piece.board.refine_grid)
        expected = [[6, 5]]
        expect(piece.trim_in_check(moves, [5, 4]).sort).to eql(expected)
      end

      it 'king in check - Queen can save' do
        piece.board.restore_board('4q3/8/8/1Q6/8/8/8/4K3 w - - 0 1')
        moves = piece.board.grid[25].call_moves(piece.board.refine_grid)
        expected = [[8, 5], [5, 5], [2, 5]].sort
        expect(piece.trim_in_check(moves, [5, 2]).sort).to eql(expected)
      end
    end
  end

  describe '#win?' do
    context 'It returns true if a checkmate is made' do
      subject(:driver) { described_class.new }
      before do
        driver.instance_variable_set('@cur_player', Player.new('', 'black'))
      end

      # win conditions

      it '#When the game is won' do
        driver.board.restore_board('3k2Q1/1R6/8/8/8/8/5B2/3K4 b - - 0 1')
        expect(driver.win?).to be_truthy
      end

      it '#When the game is won' do
        driver.board.restore_board('8/8/5NRk/5K2/8/8/8/8 b - - 0 1')
        expect(driver.win?).to be_truthy
      end

      it '#When the game is won' do
        driver.board.restore_board('8/8/8/8/8/8/2Q5/K3Q1k1 b - - 0 1')
        expect(driver.win?).to be_truthy
      end

      it '#When the game is won' do
        driver.board.restore_board('2k5/8/1KN1B3/8/8/B7/8/8 b - - 0 1')
        expect(driver.win?).to be_truthy
      end

      it '#When the game is won' do
        driver.board.restore_board('8/8/8/6B1/8/2N5/2N3K1/4k3 b - - 0 1')
        expect(driver.win?).to be_truthy
      end

      it '#When the game is not won' do
        driver.board.restore_board('2k5/B7/Q2K4/8/8/7q/8/8 b - - 0 2')
        expect(driver.win?).to be_falsy
      end

      it '#When the game is not won' do
        driver.board.restore_board('K7/B6b/4k3/8/8/8/8/Q7 b - - 0 2')
        expect(driver.win?).to be_falsy
      end

      it '#When the game is not won' do
        driver.board.restore_board('K1n3Q1/2k4B/8/8/8/8/8/8 b - - 0 2')
        expect(driver.win?).to be_falsy
      end

      it '#When the game is not won' do
        driver.board.restore_board('3k4/8/2NK4/8/Q7/8/8/6q1 b - - 0 2')
        expect(driver.win?).to be_falsy
      end

      it '#When the game is not won' do
        driver.board.restore_board('K5N1/1Q6/8/5k2/8/3b4/8/8 b - - 0 2')
        expect(driver.win?).to be_falsy
      end
    end
  end

  describe '#draw?' do
    context 'It returns true if a draw' do
      subject(:driver) { described_class.new }
      before do
        driver.instance_variable_set('@cur_player', Player.new('', 'black'))
      end

      # win conditions

      it '#When the game is draw' do
        driver.board.restore_board('3k4/8/8/8/8/8/8/3K4 w - - 0 1')
        expect(driver.draw?).to be_truthy
      end

      it '#When the game is draw' do
        driver.board.restore_board('3k4/7R/2R1R3/8/8/8/8/3K4 w - - 0 1')
        expect(driver.draw?).to be_truthy
      end

      it '#When the game is draw' do
        driver.board.restore_board('3k4/7R/6B1/5B2/8/8/8/3K4 w - - 0 1')
        expect(driver.draw?).to be_truthy
      end

      it '#When the game is draw' do
        driver.board.restore_board('k7/8/1Q6/8/8/8/8/3K4 w - - 0 1')
        expect(driver.draw?).to be_truthy
      end

      it '#When the game is draw' do
        driver.board.restore_board('k7/7R/8/8/8/8/8/1R1K4 w - - 0 1')
        expect(driver.draw?).to be_truthy
      end

      it '#When the game is not draw' do
        driver.board.restore_board('2k5/B7/Q2K4/8/8/7q/8/8 b - - 0 2')
        expect(driver.draw?).to be_falsy
      end

      it '#When the game is not draw' do
        driver.board.restore_board('K7/B6b/4k3/8/8/8/8/Q7 b - - 0 2')
        expect(driver.draw?).to be_falsy
      end

      it '#When the game is not draw' do
        driver.board.restore_board('K1n3Q1/2k4B/8/8/8/8/8/8 b - - 0 2')
        expect(driver.draw?).to be_falsy
      end

      it '#When the game is not draw' do
        driver.board.restore_board('3k4/8/2NK4/8/Q7/8/8/6q1 b - - 0 2')
        expect(driver.draw?).to be_falsy
      end

      it '#When the game is not draw' do
        driver.board.restore_board('K5N1/1Q6/8/5k2/8/3b4/8/8 b - - 0 2')
        expect(driver.draw?).to be_falsy
      end
    end
  end
end
