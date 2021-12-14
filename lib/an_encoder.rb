module Encoder
  def fen_to_board(notation)
    @grid.clear
    i = 8
    j = 1
    notation.each do |x|
      color = get_color(x)
      position = [i, j]
      @grid << create_cell(x.downcase, color, position)
      j += 1
      if j > 8
        i -= 1
        j = 1
      end
    end
  end

  def refine_notation(notation)
    array = notation.split('')
    array.delete('/')
    array.each_with_index do |x, ind|
      next unless x.between?('1', '8')

      spaces = x.to_i
      space_set = []
      spaces.times { space_set << 'emp' }
      array[ind] = space_set
    end
    array.flatten
  end

  def verify_notation(notation)
    notation.all? { |x| /^[rnbkqp]$|^emp$/i.match?(x) } &&
      notation.size == 64
  end

  KEYS = { p: Pawn, k: King, q: Queen, n: Knight, r: Rook, b: Bishop }.freeze

  def create_cell(keyword, color, position)
    Cell.new(position, KEYS[keyword.to_sym]&.new(color))
  end

  def get_color(keyword)
    keyword == keyword.upcase ? 'white' : 'black'
  end
end
