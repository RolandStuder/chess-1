module Encoder
  # ---Decoder---

  def fen_decode(notation)
    raw = notation.split(' ')
    return 'bad notation' if raw.size < 3

    restore_grid(raw[0])
    restore_rights(raw[2])

    return_turn(raw[1])
  end

  def return_turn(key)
    key == 'w' ? 'white' : 'black'
  end

  def restore_rights(notation)
    keys = { 'K' => [1, 8], 'Q' => [1, 1], 'k' => [8, 8], 'q' => [8, 1] }
    rights = notation.split('')
    keys.each_key do |key|
      next unless rights.include?(key)

      @grid[find_cell(keys[key])].piece&.instance_variable_set('@starting', true)
    end
  end

  def restore_grid(notation)
    refined_notation = refine_notation(notation)
    raise 'Invalid Fen, exiting the program now' unless verify_notation(refined_notation)

    fen_to_board(refined_notation)
  end

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
    Cell.new(position, KEYS[keyword.to_sym]&.new(color, start: start?(position, keyword, color)))
  end

  def start?(location, keyword, color)
    if keyword == 'p' && location[0] == 7 && color == 'black'
      true
    elsif keyword == 'p' && location[0] == 2 && color == 'white'
      true
    else
      keyword == 'k'
    end
  end

  def get_color(keyword)
    keyword == keyword.upcase ? 'white' : 'black'
  end

  # --- Encoder ---
  def fen_encode(turn)
    raw_n = raw_notation
    fine_n = fine_notation(raw_n)
    c_rights = castle_rights
    "#{fine_n} #{turn[0].downcase} #{c_rights}"
  end

  def fine_notation(raw)
    raw.chunk(&:itself).map do |x|
      x[0].is_a?(String) ? x[1] : x[1].sum
    end.flatten.join
  end

  def raw_notation
    @grid.map do |cell|
      cell.empty? ? 1 : get_key(cell)
    end.each_slice(8).map { |x| x << '/' }.flatten[0..-2]
  end

  def get_key(cell)
    key = cell.piece.is_a?(Knight) ? 'N' : cell.piece.class.to_s[0]
    cell.color == 'white' ? key : key.downcase
  end

  def castle_rights
    set = @grid.select { |cell| (cell.piece.is_a?(Rook) || cell.piece.is_a?(King)) && cell.piece.starting == true }
    white = rights(set.select { |cell| cell.color == 'white' }).upcase
    black = rights(set.select { |cell| cell.color == 'black' })
    set = (white + black).split('')
    return '-' if set.empty?

    set.join('')
  end

  def rights(set)
    keys = { 1 => 'q', 8 => 'k' }
    return '' if set.empty?
    return '' unless set.any? { |x| x.piece.is_a?(King) }

    rights = []
    set.select { |x| x.piece.is_a? Rook }.each do |pc|
      rights << keys[pc.location[1]]
    end
    return '' if rights.empty?

    rights.join('')
  end
end
