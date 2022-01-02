require_relative '../lib/cell'

RSpec.describe Cell do
  describe '#get_pos' do
    subject(:cell) { Cell.new([2, 5]) }
    it 'Returns the correct alphanumeric position' do
      position = cell.instance_variable_get('@position')
      expected = 'e2'
      expect(position).to eql(expected)
    end
  end
end
