require_relative '../lib/pieces'
require_relative '../lib/test_board'

RSpec.describe Pieces do
  describe '#has_moved' do
    subject(:piece) { described_class.new('white') }
    it 'sets the @starting status to false' do
      expect { piece.has_moved }.to change { piece.starting }.from(true).to false
    end
  end
end

RSpec.describe Knight do
  let(:board) { TestBoard.new.make_test_board }
  describe '#set_valid' do
    context 'It returns a single move per every set' do
      subject(:knight) { described_class.new('white') }

      it 'Returns the first available position' do
        start = [1, 1]
        increment = [2, 1]
        expected = [[3, 2]]
        expect(knight.set_valid(start, board, increment)).to eql(expected)
      end

      it 'Returns the first available position test2' do
        start = [4, 4]
        increment = [-2, -1]
        expected = [[2, 3]]
        expect(knight.set_valid(start, board, increment)).to eql(expected)
      end
    end
  end

  describe '#moave_able?' do
    context 'it trims off the unattackable tiles' do
      subject(:knight) { described_class.new('white') }

      it 'when the tile has a black pawn' do
        board[41] << 'bpawn'
        expect(knight.attack_able?([3, 2], board)).to be_truthy
      end

      it 'when the tile has a white pawn' do
        board[41] << 'wpawn'
        expect(knight.attack_able?([3, 2], board)).to be_falsy
      end
    end
  end

  describe '#next_moves' do
    context 'It refines and returns the available moves' do
      subject(:knight) { described_class.new('white') }

      it 'When the knight is at 4,4' do
        expected = [[[2, 3]], [[2, 5]], [[3, 6]], [[3, 2]], [[5, 2]], [[5, 6]], [[6, 3]], [[6, 5]]].sort
        expect(knight.next_moves([4, 4], board).sort).to eql(expected)
      end

      it 'when one of the squares is occupied by a white rook' do
        position = [1, 1]
        board[41] << 'wrook'
        expect(knight.next_moves(position, board)).to eql([[[2, 3]]])
      end

      it 'when one of the squares is occupied by a black rook' do
        position = [1, 1]
        board[41] << 'brook'
        expect(knight.next_moves(position, board).sort).to eql([[[2, 3]], [[3, 2]]].sort)
      end

      it 'returns empty array when there are no possible moves' do
        position = [1, 1]
        board[41] << 'wrook'
        board[50] << 'wpawn'
        expect(knight.next_moves(position, board)).to eql([])
      end
    end
  end
end

RSpec.describe Rook do
  let(:board) { TestBoard.new.make_test_board }
  describe '#set_valid' do
    context 'It returns the whole set of moves' do
      subject(:rook) { described_class.new('white') }

      it 'Returns the whole set of available moves in the direction' do
        start = [1, 1]
        increment = [1, 0]
        expected = [[2, 1], [3, 1], [4, 1], [5, 1], [6, 1], [7, 1], [8, 1], [9, 1]]
        expect(rook.set_valid(start, board, increment)).to eql(expected)
      end

      it 'stops when a piece is encountered' do
        board[16] << 'bpawn'
        start = [1, 1]
        increment = [1, 0]
        expected = [[2, 1], [3, 1], [4, 1], [5, 1], [6, 1]]
        expect(rook.set_valid(start, board, increment)).to eql(expected)
      end
    end
  end

  describe '#next_moves' do
    context 'it returns the correct moveset' do
      subject(:rook) { described_class.new('white') }

      it 'when the rook is at [4,4]' do
        location = [4, 4]
        expected = [[[4, 3], [4, 2], [4, 1]],
                    [[4, 5], [4, 6], [4, 7], [4, 8]],
                    [[5, 4], [6, 4], [7, 4], [8, 4]],
                    [[3, 4], [2, 4], [1, 4]]].sort
        expect(rook.next_moves(location, board).sort).to eql(expected)
      end

      it 'when the rook is at [4,4] and the rank are occupied by white pieces' do
        board[33] << 'wpawn'
        board[37] << 'wpawn'
        location = [4, 4]
        expected = [[[4, 3]],
                    [[4, 5]],
                    [[5, 4], [6, 4], [7, 4], [8, 4]],
                    [[3, 4], [2, 4], [1, 4]]].sort
        expect(rook.next_moves(location, board).sort).to eql(expected)
      end

      it 'when the rook is at [4,4] and the file is occupied by black pieces' do
        board[19] << 'bpawn'
        board[51] << 'bpawn'
        location = [4, 4]
        expected = [[[4, 3], [4, 2], [4, 1]],
                    [[4, 5], [4, 6], [4, 7], [4, 8]],
                    [[5, 4], [6, 4]],
                    [[3, 4], [2, 4]]].sort
        expect(rook.next_moves(location, board).sort).to eql(expected)
      end
    end
  end
end

RSpec.describe Bishop do
  let(:board) { TestBoard.new.make_test_board }
  describe '#set_valid' do
    context 'It returns the whole set of moves' do
      subject(:bishop) { described_class.new('white') }

      it 'Returns the whole set of available moves in the direction' do
        start = [1, 1]
        increment = [1, 1]
        expected = [[2, 2], [3, 3], [4, 4], [5, 5], [6, 6], [7, 7], [8, 8], [9, 9]]
        expect(bishop.set_valid(start, board, increment)).to eql(expected)
      end

      it 'stops when a piece is encountered' do
        board[21] << 'bpawn'
        start = [1, 1]
        increment = [1, 1]
        expected = [[2, 2], [3, 3], [4, 4], [5, 5], [6, 6]]
        expect(bishop.set_valid(start, board, increment)).to eql(expected)
      end
    end
  end

  describe '#next_moves' do
    context 'it returns the correct moveset' do
      subject(:bishop) { described_class.new('white') }

      it 'when the bishop is at [4,4]' do
        location = [4, 4]
        expected = [[[3, 3], [2, 2], [1, 1]],
                    [[5, 5], [6, 6], [7, 7], [8, 8]],
                    [[5, 3], [6, 2], [7, 1]],
                    [[3, 5], [2, 6], [1, 7]]].sort
        expect(bishop.next_moves(location, board).sort).to eql(expected)
      end

      it 'when the bishop is at [4,4] and the diagonal are occupied by white pieces' do
        board[49] << 'wpawn'
        board[21] << 'wpawn'
        location = [4, 4]
        expected = [[[3, 3]],
                    [[5, 5]],
                    [[5, 3], [6, 2], [7, 1]],
                    [[3, 5], [2, 6], [1, 7]]].sort
        expect(bishop.next_moves(location, board).sort).to eql(expected)
      end

      it 'when the bishop is at [4,4] and the file is occupied by black pieces' do
        board[17] << 'bpawn'
        board[53] << 'bpawn'
        location = [4, 4]
        expected = [[[3, 3], [2, 2], [1, 1]],
                    [[5, 5], [6, 6], [7, 7], [8, 8]],
                    [[5, 3], [6, 2]],
                    [[3, 5], [2, 6]]].sort
        expect(bishop.next_moves(location, board).sort).to eql(expected)
      end
    end
  end
end

RSpec.describe Queen do
  let(:board) { TestBoard.new.make_test_board }
  describe '#set_valid' do
    context 'It returns the whole set of moves' do
      subject(:queen) { described_class.new('white') }

      it 'Returns the whole set of available moves in the direction' do
        start = [1, 1]
        increment = [1, 1]
        expected = [[2, 2], [3, 3], [4, 4], [5, 5], [6, 6], [7, 7], [8, 8], [9, 9]]
        expect(queen.set_valid(start, board, increment)).to eql(expected)
      end

      it 'stops when a piece is encountered' do
        board[16] << 'bpawn'
        start = [1, 1]
        increment = [1, 0]
        expected = [[2, 1], [3, 1], [4, 1], [5, 1], [6, 1]]
        expect(queen.set_valid(start, board, increment)).to eql(expected)
      end
    end
  end

  describe '#next_moves' do
    context 'it returns the correct moveset' do
      subject(:queen) { described_class.new('white') }

      it 'when the queen is at [4,4]' do
        location = [4, 4]
        expected = [[[3, 3], [2, 2], [1, 1]],
                    [[5, 5], [6, 6], [7, 7], [8, 8]],
                    [[5, 3], [6, 2], [7, 1]],
                    [[3, 5], [2, 6], [1, 7]],
                    [[4, 3], [4, 2], [4, 1]],
                    [[4, 5], [4, 6], [4, 7], [4, 8]],
                    [[5, 4], [6, 4], [7, 4], [8, 4]],
                    [[3, 4], [2, 4], [1, 4]]].sort
        expect(queen.next_moves(location, board).sort).to eql(expected)
      end

      it 'when the queen is at [4,4] and the diagonals and ranks are occupied by white pieces' do
        board[49] << 'wpawn'
        board[21] << 'wpawn'
        board[33] << 'wpawn'
        board[37] << 'wpawn'
        location = [4, 4]
        expected = [[[3, 3]],
                    [[5, 5]],
                    [[5, 3], [6, 2], [7, 1]],
                    [[3, 5], [2, 6], [1, 7]],
                    [[4, 3]],
                    [[4, 5]],
                    [[5, 4], [6, 4], [7, 4], [8, 4]],
                    [[3, 4], [2, 4], [1, 4]]].sort
        expect(queen.next_moves(location, board).sort).to eql(expected)
      end

      it 'when the queen is at [4,4] and the diagonal and file is occupied by black pieces' do
        board[17] << 'bpawn'
        board[53] << 'bpawn'
        board[19] << 'bpawn'
        board[51] << 'bpawn'
        location = [4, 4]
        expected = [[[3, 3], [2, 2], [1, 1]],
                    [[5, 5], [6, 6], [7, 7], [8, 8]],
                    [[5, 3], [6, 2]],
                    [[3, 5], [2, 6]],
                    [[4, 3], [4, 2], [4, 1]],
                    [[4, 5], [4, 6], [4, 7], [4, 8]],
                    [[5, 4], [6, 4]],
                    [[3, 4], [2, 4]]].sort
        expect(queen.next_moves(location, board).sort).to eql(expected)
      end
    end
  end
end

RSpec.describe King do
  let(:board) { TestBoard.new.make_test_board }
  describe '#set_valid' do
    context 'It returns a single move per every set' do
      subject(:king) { described_class.new('white') }

      it 'Returns the first available position' do
        start = [1, 1]
        increment = [1, 0]
        expected = [[2, 1]]
        expect(king.set_valid(start, board, increment)).to eql(expected)
      end

      it 'Returns the first available position test2' do
        start = [4, 4]
        increment = [-1, -1]
        expected = [[3, 3]]
        expect(king.set_valid(start, board, increment)).to eql(expected)
      end
    end
  end

  describe '#next_moves' do
    context 'It refines and returns the available moves' do
      subject(:king) { described_class.new('white') }

      it 'When the king is at 4,4' do
        expected = [[[3, 3]], [[5, 5]], [[5, 3]], [[3, 5]], [[5, 4]], [[3, 4]], [[4, 5]], [[4, 3]]].sort
        expect(king.next_moves([4, 4], board).sort).to eql(expected)
      end

      it 'when one of the squares is occupied by a white rook' do
        position = [1, 1]
        board[48] << 'wrook'
        expect(king.next_moves(position, board).sort).to eql([[[1, 2]], [[2, 2]]].sort)
      end

      it 'when one of the squares is occupied by a black rook' do
        position = [1, 1]
        board[48] << 'brook'
        expect(king.next_moves(position, board).sort).to eql([[[2, 1]], [[2, 2]], [[1, 2]]].sort)
      end

      it 'returns empty array when there are no possible moves' do
        position = [1, 1]
        board[48] << 'wrook'
        board[49] << 'wpawn'
        board[57] << 'wqueen'
        expect(king.next_moves(position, board)).to eql([])
      end
    end
  end
end

RSpec.describe Pawn do
  let(:board) { TestBoard.new.make_test_board }
  describe '#set_valid' do
    context 'It outputs the correct tiles from the set' do
      subject(:pawn) { described_class.new('white') }
      it 'When the pawn is at [2,1] and has not moved yet' do
        position = [2, 1]
        increment = [1, 0]
        expected = [[3, 1], [4, 1]].sort
        expect(pawn.set_valid(position, board, increment).sort).to eql(expected)
      end

      it 'When the pawn has moved' do
        pawn.has_moved
        position = [2, 1]
        increment = [1, 0]
        expected = [[3, 1]].sort
        expect(pawn.set_valid(position, board, increment).sort).to eql(expected)
      end

      it "should return the tile even if it's occupied" do
        board[32] << 'wrook'
        position = [2, 1]
        increment = [1, 0]
        expected = [[3, 1], [4, 1]].sort
        expect(pawn.set_valid(position, board, increment).sort).to eql(expected)
      end
    end
  end

  describe '#all_moves' do
    context 'When the pawn is black, it should return all the moves' do
      subject(:bpawn) { described_class.new('black') }

      it 'Should return the attacks and moves when the pawn has not moved' do
        position = [7, 2]
        expected = [[[6, 2], [5, 2]], [[6, 1], [6, 3]]]
        expect(bpawn.all_moves(position, board)).to eql(expected)
      end

      it 'For a border pawn which is not moved' do
        position = [7, 1]
        expected = [[[6, 1], [5, 1]], [[6, 2]]]
        expect(bpawn.all_moves(position, board)).to eql(expected)
      end

      it 'When the pawn has moved' do
        bpawn.has_moved
        position = [7, 2]
        expected = [[[6, 2]], [[6, 1], [6, 3]]]
        expect(bpawn.all_moves(position, board)).to eql(expected)
      end

      it 'when the pawn has not moved a piece is blocking the second step' do
        board[25] << 'wpawn'
        position = [7, 2]
        expected = [[[6, 2]], [[6, 1], [6, 3]]]
        expect(bpawn.all_moves(position, board)).to eql(expected)
      end

      it 'when the pawn has not moved a piece is blocking the first step' do
        board[17] << 'bpawn'
        position = [7, 2]
        expected = [[], [[6, 1], [6, 3]]]
        expect(bpawn.all_moves(position, board)).to eql(expected)
      end
    end

    context 'When the pawn is white, it returns all moves' do
      subject(:wpawn) { described_class.new('white') }

      it 'Should return the attacks and moves when the pawn has not moved' do
        position = [2, 2]
        expected = [[[3, 2], [4, 2]], [[3, 1], [3, 3]]]
        expect(wpawn.all_moves(position, board)).to eql(expected)
      end

      it 'For a border pawn which is not moved' do
        position = [2, 1]
        expected = [[[3, 1], [4, 1]], [[3, 2]]]
        expect(wpawn.all_moves(position, board)).to eql(expected)
      end

      it 'When the pawn has moved' do
        wpawn.has_moved
        position = [2, 2]
        expected = [[[3, 2]], [[3, 1], [3, 3]]]
        expect(wpawn.all_moves(position, board)).to eql(expected)
      end

      it 'when the pawn has not moved a piece is blocking the second step' do
        board[33] << 'wpawn'
        position = [2, 2]
        expected = [[[3, 2]], [[3, 1], [3, 3]]]
        expect(wpawn.all_moves(position, board)).to eql(expected)
      end

      it 'when the pawn has not moved a piece is blocking the first step' do
        board[41] << 'bpawn'
        position = [2, 2]
        expected = [[], [[3, 1], [3, 3]]]
        expect(wpawn.all_moves(position, board)).to eql(expected)
      end
    end
  end

  describe '#refine_attacks' do
    context 'It checks if a tile is attackable' do
      subject(:wpawn) { described_class.new('white') }
      it 'when the tiles are empty' do 
        attacks = [[3,1],[3,3]]
        expect(wpawn.refine_attacks(attacks, board)).to eql([])
      end

      it 'when the tiles are occupied by white pieces' do 
        board[40] << 'wpawn'
        board[43] << 'wpawn'
        attacks = [[3,1],[3,3]]
        expect(wpawn.refine_attacks(attacks, board)).to eql([])
      end

      it 'when the tiles are occupied by black pieces' do 
        board[40] << 'bpawn'
        board[42] << 'bpawn'
        attacks = [[3,1],[3,3]]
        expect(wpawn.refine_attacks(attacks, board)).to eql(attacks)
      end
    end
  end

  describe '#nexT_moves' do 
    context 'It should output the correct refined moves for the pawn' do 
      subject(:wpawn) {described_class.new('white')}

      it 'when the pawn is moved, and can attack a black pc to right' do 
        wpawn.has_moved
        location = [2,2]
        board[42] << 'bpawn'
        expected = [[[3,2]], [[3,3]]]
        expect(wpawn.next_moves(location, board)).to eql(expected)
      end

      it 'Outputs empty array when there are no moves' do 
        location = [2,2]
        board[41] << 'wpawn'
        expect(wpawn.next_moves(location, board)).to eql([[],[]])
      end
    end
  end
end
