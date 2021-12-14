require_relative '../lib/pieces'

RSpec.describe Knight do
  describe '#next_moves' do
    context 'Outputs correct moves' do
      subject(:knight) { described_class.new('') }
      it 'For location 2,1' do
        cur_location = [2, 1]
        outcome = [[1, 3], [3, 3], [4, 2]]
        expect(knight.next_moves(cur_location).sort).to eql(outcome.sort)
      end
    end
  end
end

RSpec.describe Rook do
  describe '#next_moves' do
    context 'It returns all the legal moves' do
      subject(:rook) { described_class.new('') }
      before do
        rook.make_test_board
        rook.test_board[rook.test_board.index([2, 4])] = 'pawn'
        rook.test_board[rook.test_board.index([4, 7])] = 'pawn'
        rook.test_board[rook.test_board.index([7, 4])] = 'pawn'
      end
      it 'When the board is populated' do
        board = rook.test_board
        position = [4, 4]
        expected = [[4, 3], [4, 2], [4, 1], [3, 4], [2, 4], [4, 5], [4, 6], [4, 7], [5, 4], [6, 4], [7, 4]].sort
        actual = rook.next_moves(position, board).sort
        expect(actual).to eql(expected)
      end
    end
  end

  describe '#set_valid' do
    context 'It returns the valid moves only' do
      subject(:rook) { described_class.new('') }
      it 'Keeps within range' do
        board = [[1, 1], [2, 1], [3, 1]]
        start = [3, 1]
        increment = [-1, 0]
        expect(rook.set_valid(start, board, increment)).to eql([[2, 1], [1, 1]])
      end

      it 'stops when a piece is encountered' do
        board = [[1, 1], [2, 1], [3, 1], 'pawn', [5, 1]]
        start = [1, 1]
        increment = [1, 0]
        expect(rook.set_valid(start, board, increment)).to eql([[2, 1], [3, 1], [4, 1]])
      end
    end
  end
end

RSpec.describe Bishop do
  describe '#next_moves' do
    context 'It returns all the legal moves' do
      subject(:bishop) { described_class.new('') }
      before do
        bishop.make_test_board
        bishop.test_board[bishop.test_board.index([6, 6])] = 'pawn'
        bishop.test_board[bishop.test_board.index([2, 6])] = 'pawn'
      end
      it 'When the board is populated' do
        board = bishop.test_board
        position = [4, 4]
        expected = [[3, 3], [2, 2], [1, 1], [3, 5], [2, 6], [5, 3], [6, 2], [7, 1], [5, 5], [6, 6]].sort
        actual = bishop.next_moves(position, board).sort
        expect(actual).to eql(expected)
      end
    end
  end

  describe '#set_valid' do
    context 'It returns the valid moves only' do
      subject(:bishop) { described_class.new('') }
      it 'Keeps within range' do
        board = [[1, 1], [2, 2], [3, 3]]
        start = [3, 3]
        increment = [-1, -1]
        expect(bishop.set_valid(start, board, increment)).to eql([[2, 2], [1, 1]])
      end

      it 'stops when a piece is encountered' do
        board = [[1, 1], [2, 2], [3, 3], 'pawn', [5, 5]]
        start = [1, 1]
        increment = [1, 1]
        expect(bishop.set_valid(start, board, increment)).to eql([[2, 2], [3, 3], [4, 4]])
      end
    end
  end
end

RSpec.describe Queen do
  describe '#next_moves' do
    context 'it outputs all legal moves' do
      subject(:queen) { described_class.new('') }
      before do
        queen.make_test_board

        queen.test_board[queen.test_board.index([2, 4])] = 'pawn'
        queen.test_board[queen.test_board.index([4, 7])] = 'pawn'
        queen.test_board[queen.test_board.index([7, 4])] = 'pawn'
        queen.test_board[queen.test_board.index([6, 6])] = 'pawn'
        queen.test_board[queen.test_board.index([2, 6])] = 'pawn'
      end

      it 'When the board is populated' do
        board = queen.test_board
        position = [4, 4]
        expected = [[3, 3], [2, 2], [1, 1], [3, 5], [2, 6], [5, 3], [6, 2], [7, 1], [5, 5], [6, 6],
                    [4, 3], [4, 2], [4, 1], [3, 4], [2, 4], [4, 5], [4, 6], [4, 7], [5, 4], [6, 4], [7, 4]].sort
        actual = queen.next_moves(position, board).sort
        expect(actual).to eql(expected)
      end
    end
  end
end

RSpec.describe Pawn do
  describe '#next_moves' do
    context 'it outputs the corrent moves' do
      subject(:pawn) { described_class.new('') }
      before do
        pawn.make_test_board
      end

      it 'When the pawn has not moved' do
        board = pawn.test_board
        position = [1, 1]
        expected = [[2, 1], [3, 1]]
        expect(pawn.next_moves(position, board).sort).to eql(expected.sort)
      end

      it 'when the pawn has moved' do
        pawn.instance_variable_set('@starting', false)
        board = pawn.test_board
        position = [1, 1]
        expected = [[2, 1]]
        expect(pawn.next_moves(position, board).sort).to eql(expected.sort)
      end
    end
  end
end

RSpec.describe King do
  describe '#next_moves' do
    subject(:king) { described_class.new('') }
    before do
      king.make_test_board
    end

    it 'outputs the correct moves' do
      board = king.test_board
      position = [1, 1]
      expected = [[2, 1], [2, 2], [1, 2]].sort
      expect(king.next_moves(position, board).sort).to eql(expected)
    end
  end
end
