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

  def display_grid(grid)
    grid.each do |x|
      tile = get_tile(x)
      tile = put_piece(x, tile) unless x.size == 2
      print tile.join('')
      print "\n" if line_break?(x)
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
    tile.each { |x| x.strip! }
    piece = PCS[lp[2].to_sym]
    tile.insert(1, piece)
  end

  def line_break?(location)
    location[1] == 8
  end

  def get_input
    puts 'enter your choice lmao'
    gets.chomp
  end

  def bot_pvp?
    puts "Do you want to play with computer or another player?"
    puts "Press 1 for 2 players"
    puts 'Press 2 for computer game'
    gets.chomp
  end

  def get_names(player)
    puts "Please enter the name for #{player}"
    gets.chomp
  end

end
