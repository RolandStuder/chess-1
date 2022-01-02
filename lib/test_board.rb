class TestBoard
  attr_accessor :test_board

  def initialize
    @test_board = []
  end

  def make_test_board
    (1..8).to_a.reverse.each do |i|
      (1..8).each do |j|
        @test_board << [i, j]
      end
    end
    @test_board
  end
end
