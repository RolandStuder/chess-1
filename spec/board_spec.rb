require_relative '../lib/board'

RSpec.describe Board do
  describe '#create_new_board' do
    context 'It creates a new grid properly'
    subject(:board) { described_class.new }

    before do
      allow(board).to receive(:verify_notation).and_return(true)
    end

    it 'Changes the grid size to 64' do
      expect { board.create_new_board }.to change { board.grid.size }.to(64)
    end
  end

  describe '#refine_grid' do
    context 'It converts the grid objects to arrays' do
      subject(:board) { described_class.new }

      before do
        board.create_new_board
      end

      it 'Outputs the correct grid from a new board' do
        grid_template1 = [[8, 1, 'brook'], [8, 2, 'bknight'], [8, 3, 'bbishop']]
        grid_template2 = [[6, 1], [6, 2], [6, 3]]
        grid_template3 = [[1, 1, 'wrook'], [1, 2, 'wknight'], [1, 3, 'wbishop']]
        output = board.refine_grid

        expect(output[0..2]).to eql(grid_template1)
        expect(output[16..18]).to eql(grid_template2)
        expect(output[56..58]).to eql(grid_template3)
      end

      it 'When the grid has no pieces' do
        board.restore_board('8/8/8/8/8/8/8/8 w -')
        output = board.refine_grid.all? { |x| x.size == 2 }

        expect(output).to be_truthy
      end
    end
  end

  describe '#filter_mark' do
    context 'It filters the inputs and sends it to correct markers' do
      subject(:board) { described_class.new }
      let(:cell) { double('cell') }
      before do
        allow(cell).to receive(:location).and_return('')
        allow(board).to receive(:rook_castle)
        allow(board).to receive(:king_castle)
        allow(board).to receive(:en_passant)
        allow(board).to receive(:mark_grid)
        allow(board).to receive(:get_cells).and_return([cell, cell])
      end

      it 'When the input signals a castle by selecting the rook' do
        allow(board).to receive(:rook_and_king?).and_return(true)
        expect(board).to receive(:rook_castle).once
        board.filter_mark('', '')
      end

      it 'When the input signals a castle by selecting the King' do
        allow(board).to receive(:rook_and_king?).and_return(false)
        allow(board).to receive(:king_and_castle?).and_return(true)
        expect(board).to receive(:king_castle).once
        board.filter_mark('', '')
      end

      it 'When the input signals en passant' do
        allow(board).to receive(:rook_and_king?).and_return(false)
        allow(board).to receive(:king_and_castle?).and_return(false)
        allow(board).to receive(:pawn_and_en_passant?).and_return(true)
        expect(board).to receive(:en_passant).once
        board.filter_mark('', '')
      end

      it 'When the input signals a normal move' do
        allow(board).to receive(:rook_and_king?).and_return(false)
        allow(board).to receive(:king_and_castle?).and_return(false)
        allow(board).to receive(:pawn_and_en_passant?).and_return(false)
        expect(board).to receive(:mark_grid).once
        board.filter_mark('', '')
      end
    end
  end

  describe '#rook_and_king?' do
    context 'It checks if the selected pieces are a rook and king' do
      subject(:board) { described_class.new }
      before do
        board.create_new_board
      end

      it 'should return true when the selection is rook and king' do
        cells = [board.grid[0], board.grid[4]]
        expect(board.rook_and_king?(cells)).to be_truthy
      end

      it 'should return false when the selection is king and rook' do
        cells = [board.grid[0], board.grid[4]].reverse
        expect(board.rook_and_king?(cells)).to be_falsy
      end

      it 'should return false for all other selections' do
        cells = [board.grid[1], board.grid[2]]
        expect(board.rook_and_king?(cells)).to be_falsy
      end
    end
  end

  describe '#king_and_castle' do
    context 'It checks if cell1 is king and second one signals castle' do
      subject(:board) { described_class.new }
      before do
        board.create_new_board
      end

      it 'should return true when the inputs are king and 2 space diff cell' do
        cells = [board.grid[4], board.grid[2]]
        expect(board.king_and_castle?(cells)).to be_truthy
      end

      it 'should return false for all other selections' do
        cells = [board.grid[4], board.grid[3]]
        expect(board.king_and_castle?(cells)).to be_falsy
      end

      it 'should return false for all other selections 2' do
        cells = [board.grid[10], board.grid[3]]
        expect(board.king_and_castle?(cells)).to be_falsy
      end
    end
  end

  describe 'pawn_and_en_passant?' do
    context 'It returns true when an input signals en passant' do
      subject(:board) { described_class.new }
      before do
        board.create_new_board
      end

      it 'should return true for valid selection' do
        cells = [board.grid[48], board.grid[42]]
        expect(board.pawn_and_en_passant?(cells)).to be_truthy
      end

      it 'should return false for pawn other selection' do
        board.mark_grid('b2', 'b3')
        cells = [board.grid[48], board.grid[41]]
        expect(board.pawn_and_en_passant?(cells)).to be_falsy
      end

      it 'should return false for other selection' do
        cells = [board.grid[34], board.grid[41]]
        expect(board.pawn_and_en_passant?(cells)).to be_falsy
      end
    end
  end

  describe '#mark_grid' do
    context 'It marks the grid as per the selection' do
      subject(:board) { described_class.new }

      before do
        board.create_new_board
      end

      it 'When the white knight moves from b1 to c3' do
        piece = board.grid[57].piece
        expect { board.mark_grid('b1', 'c3') }
          .to change { board.grid[57].piece }.to(nil)
                                             .and change { board.grid[42].piece }.to(piece)
      end

      it 'When the white pawn moves from b2 to b4' do
        piece = board.grid[49].piece
        expect { board.mark_grid('b2', 'b4') }
          .to change { board.grid[49].piece }.to(nil)
                                             .and change { board.grid[33].piece }.to(piece)
      end

      it 'When the black rook moves from a8 to a1' do
        piece = board.grid[0].piece
        expect { board.mark_grid('a8', 'a1') }
          .to change { board.grid[0].piece }.to(nil)
                                            .and change { board.grid[56].piece }.to(piece)
      end
    end
  end

  describe '#rook_castle' do
    context 'It makes the special castle move (Rook to king and king to sway 2)' do
      subject(:board) { described_class.new }
      before do
        board.create_new_board
      end

      it "white's Kingside castling" do
        rook = board.grid[63].piece
        king = board.grid[60].piece
        expect { board.rook_castle([1, 8], [1, 5]) }
          .to change { board.grid[63].piece }.to(nil)
                                             .and change { board.grid[60].piece }.to(rook)
                                                                                 .and change {
                                                                                        board.grid[62].piece
                                                                                      }.to(king)
      end

      it "Black's queenside castling" do
        rook = board.grid[0].piece
        king = board.grid[4].piece
        expect { board.rook_castle([8, 1], [8, 5]) }
          .to change { board.grid[0].piece }.to(nil)
                                            .and change { board.grid[4].piece }.to(rook)
                                                                               .and change {
                                                                                      board.grid[2].piece
                                                                                    }.to(king)
      end
    end
  end

  describe '#king_castle' do
    context 'It makes the special castle move (Rook to king and king to sway 2)' do
      subject(:board) { described_class.new }
      before do
        board.create_new_board
      end

      it "white's Kingside castling" do
        rook = board.grid[63].piece
        king = board.grid[60].piece
        expect { board.king_castle([1, 5], [1, 7]) }
          .to change { board.grid[63].piece }.to(nil)
                                             .and change { board.grid[60].piece }.to(rook)
                                                                                 .and change {
                                                                                        board.grid[62].piece
                                                                                      }.to(king)
      end

      it "Black's queenside castling" do
        rook = board.grid[0].piece
        king = board.grid[4].piece
        expect { board.king_castle([8, 5], [8, 3]) }
          .to change { board.grid[0].piece }.to(nil)
                                            .and change { board.grid[4].piece }.to(rook)
                                                                               .and change {
                                                                                      board.grid[2].piece
                                                                                    }.to(king)
      end
    end
  end

  describe '#en_passant' do
    context 'makes an en_passant move properly' do
      subject(:board) { described_class.new }

      before do
        board.create_new_board
      end

      it 'When en passant is allowed for a white pawn at a5' do
        board.mark_grid('a2', 'a5')
        board.mark_grid('b7', 'b5')
        wpawn = board.grid[24].piece
        expect { board.en_passant(board.grid[24], [5, 1], [6, 2]) }
          .to change { board.grid[24].piece }.to(nil)
                                             .and change { board.grid[25].piece }.to(nil)
                                                                                 .and change {
                                                                                        board.grid[17].piece
                                                                                      }.to(wpawn)
      end

      it 'When en passant is allowed for a black pawn at b4' do
        board.mark_grid('b7', 'b4')
        board.mark_grid('c2', 'c4')
        bpawn = board.grid[33].piece
        expect { board.en_passant(board.grid[33], [4, 2], [3, 3]) }
          .to change { board.grid[33].piece }.to(nil)
                                             .and change { board.grid[34].piece }.to(nil)
                                                                                 .and change {
                                                                                        board.grid[42].piece
                                                                                      }.to(bpawn)
      end
    end
  end

  describe '#find_cell' do
    context 'It returns the index of notation' do
      subject(:board) { described_class.new }
      before do
        board.create_new_board
      end

      it 'shoud return 0 for a8' do
        expect(board.find_cell('a8')).to eql(0)
      end

      it 'should return 7 for [1, 8]' do
        expect(board.find_cell([8, 8])).to eql(7)
      end

      it 'should return 52 for e2' do
        expect(board.find_cell('e2')).to eql(52)
      end
    end
  end

  describe '#get_cells' do
    context 'returns an array of two cells' do
      subject(:board) { described_class.new }
      before do
        board.create_new_board
      end

      it 'returns correct cells for a1 and a8' do
        expected = [board.grid[56], board.grid[0]]
        expect(board.get_cells('a1', 'a8')).to eql(expected)
      end

      it 'returns correct cells for [1, 1] and [8, 1]' do
        expected = [board.grid[56], board.grid[0]]
        expect(board.get_cells([1, 1], [8, 1])).to eql(expected)
      end
    end
  end

  describe '#restore_board' do
    context 'It restores the board using the fen' do
      subject(:board) { described_class.new }

      it 'does not restore the board for bad notation' do
        input = ''
        expect(board).to_not receive(:fen_to_board)
        board.restore_board(input)
      end

      it 'restores the board with valid notation' do
        input = '8/8/8/8/8/8/8/8 w -'
        expect { board.restore_board(input) }.to change { board.grid.size }.to(64)
      end
    end
  end

  describe '#cloner' do
    subject(:board) { described_class.new }

    it 'clones the dummy' do
      dummy = [[1], [2]]
      expect { board.cloner(dummy) }.to change { board.grid }.to(dummy)
    end
  end

  describe '#update_moved' do
    context 'It sends message to the selected piece to update the moved status' do
      subject(:board) { described_class.new }
      let(:piece) { double('piece') }
      before do
        board.create_new_board
        allow(piece).to receive(:has_moved)
      end

      it 'Should send the message to the pawn at a2' do
        board.grid[0].instance_variable_set('@piece', piece)
        expect(piece).to receive(:has_moved).once
        board.update_moved('a8')
      end

      it 'Should send the message to the queen at d1' do
        board.grid[59].instance_variable_set('@piece', piece)
        expect(piece).to receive(:has_moved).once
        board.update_moved('d1')
      end
    end
  end

  describe '#replace_piece' do
    context 'It replaces the piece at the location with a new one' do
      subject(:board) { described_class.new }
      let(:new_piece) { double('Piece') }

      before do
        board.create_new_board
        allow(Pieces).to receive(:new).and_return(new_piece)
      end

      it 'Replaces piece at a8 with new_piece' do
        expect { board.replace_piece(board.grid[0], 'q', '') }
          .to change { board.grid[0].piece }.to(new_piece)
      end
    end
  end

  # ---- Module Encoder -----

  describe '#fen_to_board' do
    context 'It restores the board using the fen' do
      subject(:board) { described_class.new }
      before do
        allow(board).to receive(:create_cell).and_return('')
      end

      it 'Creates a new grid from the fen' do
        input = Array.new(64, '')
        expect { board.fen_to_board(input) }.to change { board.grid }.to(input)
      end
    end
  end

  describe '#refine_notation' do
    context 'converts the string input to refined array' do
      subject(:board) { described_class.new }

      it 'should return a refined array for a normal row' do
        input = 'rn/kq'
        expected = %w[r n k q]
        expect(board.refine_notation(input)).to eql(expected)
      end

      it 'puts appropriate empty spaces' do
        input = '2n/4'
        expected = %w[emp emp n emp emp emp emp]
        expect(board.refine_notation(input)).to eql(expected)
      end
    end
  end

  describe '#verify_notation' do
    context 'it returns false for invalid notations' do
      subject(:board) { described_class.new }

      it 'returns true for correct keywords' do
        input = %w[k q emp]
        allow(input).to receive(:size).and_return(64)
        expect(board.verify_notation(input)).to be_truthy
      end

      it 'returns false for invalid keywords' do
        input = %w[k q z]
        allow(input).to receive(:size).and_return(64)
        expect(board.verify_notation(input)).to be_falsy
      end

      it 'checks for the correct size' do
        input = Array.new(64)
        allow(input).to receive(:all?).and_return(true)
        expect(board.verify_notation(input)).to be_truthy
      end

      it 'checks for both the size and keywords' do
        input = %w[k q n emp] * 16
        expect(board.verify_notation(input)).to be_truthy
      end

      it 'checks for both the size and keywords' do
        input = %w[k q n d] * 14
        expect(board.verify_notation(input)).to be_falsy
      end
    end
  end

  describe '#create_cell' do
    context 'it created new cells with correct pieces per keyword' do
      subject(:board) { described_class.new }
      it 'when the keyword is q' do
        expect(Cell).to receive(:new)
        expect(Queen).to receive(:new).with('white', { start: false })
        board.create_cell('q', 'white', [1, 2])
      end

      it 'when the keyword is n' do
        expect(Cell).to receive(:new)
        expect(Knight).to receive(:new).with('black', { start: false })
        board.create_cell('n', 'black', [2, 1])
      end

      it 'when the keyword is b' do
        expect(Cell).to receive(:new)
        expect(Bishop).to receive(:new).with('black', { start: false })
        board.create_cell('b', 'black', [2, 1])
      end

      it 'when the keyword is p' do
        expect(Cell).to receive(:new)
        expect(Pawn).to receive(:new).with('white', { start: true })
        board.create_cell('p', 'white', [2, 1])
      end

      it 'when the keyword is k' do
        expect(Cell).to receive(:new)
        expect(King).to receive(:new).with('black', { start: true })
        board.create_cell('k', 'black', [2, 1])
      end

      it 'when the keyword is emp' do
        expect(Cell).to receive(:new)
        expect(Pieces).to_not receive(:new)
        board.create_cell('emp', 'any', [1, 2])
      end
    end
  end

  describe '#get_color' do
    context 'It returns the correct color' do
      subject(:board) { described_class.new }

      it 'should return white for upcase' do
        keyword = 'Q'
        expect(board.get_color(keyword)).to eql('white')
      end

      it 'should return black for lowercase' do
        keyword = 'q'
        expect(board.get_color(keyword)).to eql('black')
      end
    end
  end

  describe '#return_turn' do
    context 'Should return the correct color per keyword' do
      subject(:board) { described_class.new }
      it 'when the keyword is w' do
        expect(board.return_turn('w')).to eql('white')
      end

      it 'when the keyword is b' do
        expect(board.return_turn('b')).to eql('black')
      end
    end
  end

  describe '#restore_rights' do
    context 'It sets the castling rights for pieces' do
      subject(:board) { described_class.new }
      before do
        board.fen_decode('r6r/8/8/8/8/8/8/R6R w -')
      end

      let(:q) { board.grid[0] }
      let(:k) { board.grid[7] }
      let(:wq) { board.grid[56] }
      let(:wk) { board.grid[63] }

      RSpec::Matchers.define_negated_matcher :not_change, :change

      it 'When KQqk is passed in' do
        expect { board.restore_rights('KQkq') }.to change { q.piece.starting }.to(true)
                                                                              .and change { k.piece.starting }.to(true)
                                                                                                              .and change {
                                                                                                                     wq.piece.starting
                                                                                                                   }.to(true)
          .and change {
                 wk.piece.starting
               }.to(true)
      end

      it 'when - is passed in' do
        expect { board.restore_rights('-') }.to not_change { q.piece.starting }
          .and not_change { k.piece.starting }
          .and not_change { wq.piece.starting }
          .and not_change { wk.piece.starting }
      end

      it 'when Qq is passed in' do
        expect { board.restore_rights('Qq') }.to change { q.piece.starting }.to(true)
                                                                            .and not_change { k.piece.starting }
          .and change { wq.piece.starting }.to(true)
                                           .and not_change { wk.piece.starting }
      end
    end
  end

  # -- encoder--
end
