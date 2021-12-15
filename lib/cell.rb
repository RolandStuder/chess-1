class Cell
  attr_reader :position, :location
  attr_accessor :piece

  def initialize(location, piece = nil)
    @location = location
    @position = get_pos(location)
    @piece = piece
  end

  def get_pos(location)
    arr = ('a'..'h').to_a
    [arr[location[1] - 1], location[0]].join('')
  end
end
