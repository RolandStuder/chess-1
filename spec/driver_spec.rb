require_relative '../lib/driver'

RSpec.describe Driver do
  context 'testing messages' do
    subject(:driver) { described_class.new }
    let(:board) { instance_double(Board) }

    before do
      driver.instance_variable_set('@board', board)
    end

    describe '#init_board' do
      it 'sends a message to initialize board' do
        expect(board).to receive(:create_new_board).once
        driver.init_board
      end
    end

    describe '#receive_input' do
      it 'sends a message to mark the board' do
        expect(board).to receive(:mark_grid).once
        driver.receive_input('a1', 'a1')
      end
    end

    describe 'send_grid' do
      it 'sends a message to refine grid' do
        expect(board).to receive(:refine_grid).once
        driver.send_grid
      end
    end
  end

  context 'Checking movement rules' do
    let(:board) { Board.new }
    before { board.create_new_board }
    let(:tile_rook_black) { board.grid[0] }
    let(:tile_pawn_white) { board.grid[48] }
    let(:tile_empty) { board.grid[18] }
    let(:tile_empty_movable) { board.grid[40] }

    describe '#not_empty?' do
      subject(:driver) { described_class.new }
      it 'returns true when tile is not empty' do
        expect(driver.not_empty?(tile_pawn_white)).to be_truthy
      end

      it 'returns false when tile is empty' do
        expect(driver.not_empty?(tile_empty)).to be_falsy
      end
    end

    describe '#belongs_to?' do
      subject(:driver) { described_class.new }
      it 'Returns true when the color matches' do
        driver.instance_variable_set('@cur_player', Player.new('', 'white'))
        expect(driver.belongs_to?(tile_pawn_white)).to be_truthy
      end
    end

    describe '#has_moves?' do
      subject(:driver) { described_class.new }
      it 'returns true if the piece has moves' do
        driver.init_board
        expect(driver.has_moves?(tile_pawn_white)).to be_truthy
      end
    end

    describe '#can_move?' do
      subject(:driver) { described_class.new }
      it 'returns true if the piece can move' do
        driver.init_board
        expect(driver.can_move?(tile_pawn_white, tile_empty_movable)).to be_truthy
      end
    end
  end
end
