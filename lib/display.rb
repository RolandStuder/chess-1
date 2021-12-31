module Display
  PCS = {
    wking: " \u265A ",
    wqueen: " \u265B ",
    wrook: " \u265C ",
    wbishop: " \u265D ",
    wknight: " \u265E ",
    wpawn: " \u265F ",
    bking: " \u2654 ",
    bqueen: " \u2655 ",
    brook: " \u2656 ",
    bbishop: " \u2657 ",
    bknight: " \u2658 ",
    bpawn: " \u2659 "
  }.freeze
  INDENT = '  a  b  c  d  e  f  g  h'.freeze
  def display_grid(grid, moves)
    system('clear')
    puts INDENT
    print '8'
    grid.each do |x|
      tile = mark_tile(get_tile(x), moves, x)
      tile = put_piece(x, tile) unless x.size == 2
      print tile.join('')
      print "#{x[0]}\n#{x[0] - 1}" if line_break?(x)
    end
    puts "1\n#{INDENT}"
  end

  def mark_tile(tile, moves, location)
    return tile unless moves.include?(location[0..1])

    if location.size == 3
      ["\u001b[41m ", "  \u001b[0m"]
    else
      tile.map(&:strip).insert(1, "\u001b[31m \u25CF ")
    end
  end

  def get_tile(location)
    dark = ["\u001b[43m ", "  \u001b[0m"]
    light = ["\u001b[45m ", "  \u001b[0m"]
    if location[0].even?
      location[1].even? ? dark : light
    else
      location[1].even? ? light : dark
    end
  end

  def put_piece(lp, tile)
    tile.each(&:strip!)
    piece = PCS[lp[2].to_sym]
    tile.insert(1, piece)
  end

  def line_break?(location)
    return false if location[0..1] == [1, 8]

    location[1] == 8
  end

  def bot_pvp?
    puts 'Do you want to play with computer or another player?'
    puts 'Press 1 for 2 players'
    puts 'Press 2 for computer game'
    input = gets.chomp
    until %w[1 2].include?(input)
      puts 'Invalid entry, try again'
      input = gets.chomp
    end
    input
  end

  def get_names(player)
    puts "Please enter the name for #{player}"
    gets.chomp
  end

  def disp_upgrade
    puts 'Congrats, your pawn can upgrade'
    puts 'Enter q for Queen'
    puts 'Enter r for Rook'
    puts 'Enter n for Knight'
    puts 'Enter b for Bishop'
    input = gets.chomp.downcase
    until /^[qrnb]$/.match?(input)
      puts 'invalid entry, try again!'
      input = gets.chomp.downcase
    end
    input
  end

  def disp_winner(winner)
    puts "Checkmate! #{winner} has won the game!"
  end

  def disp_draw
    puts 'This game has ended in a draw'
  end

  def type_input
    puts 'Press 1 for a new game'
    puts 'Press 2 to load a previous game'
    input = gets.chomp
    until %w[1 2].include?(input)
      puts 'Invalid entry, try again'
      input = gets.chomp
    end
    input
  end

  def disp_save
    puts 'Press 1 to save'
    puts 'Press any other key to continue'
    gets.chomp
  end
end
