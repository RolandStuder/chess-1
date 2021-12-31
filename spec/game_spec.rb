require_relative '../lib/game'

RSpec.describe Game do
  let(:driver) { instance_double(Logic) }
  describe 'generate_id' do
    context 'It generates a unique id for each game' do
      subject(:game) { described_class.new }

      it 'Test one' do
        expect(game.generate_id.split('')).to all(be_between('1', '9'))
      end

      it 'Test two' do
        expect(game.generate_id.split('').size).to eql(5)
      end
    end
  end

  describe 'get_grid' do
    subject(:game) { described_class.new }
    it 'should send a message to the main driver to send the grid' do
      game.instance_variable_set('@driver', driver)
      expect(driver).to receive(:send_grid).once
      game.get_grid
    end
  end

  describe 'upgrade_possible?' do
    context 'expext driver -to recive piece upgrade message if the update is possible' do
      subject(:game) { described_class.new }
      before do
        game.instance_variable_set('@driver', driver)
        allow(game).to receive(:disp_upgrade)
      end

      it 'When the upgrade is not possible' do
        allow(driver).to receive(:can_upgrade?).and_return(false)
        expect(driver).not_to receive(:upgrade)
        game.upgrade_possible?
      end

      it 'When the upgrade is possible' do
        allow(driver).to receive(:can_upgrade?).and_return(true)
        expect(driver).to receive(:upgrade).once
        game.upgrade_possible?
      end
    end
  end

  describe '#make_board' do
    subject(:game) { described_class.new }
    before do
      game.instance_variable_set('@driver', driver)
      allow(game).to receive(:make_players)
    end

    it 'Should send a message to create a board' do
      expect(driver).to receive(:init_board).once
      expect(game).to receive(:make_players).once
      game.make_board
    end
  end

  describe '#call_inputs' do
    subject(:game) { described_class.new }
    before do
      game.instance_variable_set('@driver', driver)
      allow(game).to receive(:display)
    end

    it 'Calls the input methods from the driver' do
      expect(driver).to receive(:select_piece)
      expect(driver).to receive(:send_moves)
      expect(driver).to receive(:select_move)
      game.call_inputs
    end
  end

  describe '#send_inputs' do
    subject(:game) { described_class.new }
    before do
      game.instance_variable_set('@driver', driver)
      allow(game).to receive(:call_inputs).and_return([1, 2])
    end

    it 'Sends a message to driver to process and mark the input' do
      expect(driver).to receive(:receive_input).with(1, 2).once
      game.send_inputs
    end
  end

  describe '#game_type' do
    subject(:game) { described_class.new }
    before do
      game.instance_variable_set('@driver', driver)

      allow(game).to receive(:load_game)
    end

    it 'Makes a new game when the input is 1' do
      allow(game).to receive(:type_input).and_return('1')
      expect(game).to receive(:make_board).once
      game.game_type
    end

    it 'loads an old game when the input is 2' do
      allow(game).to receive(:type_input).and_return('2')
      expect(game).to receive(:load_game).once
      game.game_type
    end
  end
end
