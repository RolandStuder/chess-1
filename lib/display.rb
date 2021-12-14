module Display
  PCS = {
    wking: " \u2654 ",
    wqueen: " \u2655 ",
    wrook: " \u2656 ",
    wbishop: " \u2657 ",
    wknight: " \u2658 ",
    wpawn: " \u2659 ",
    bking: " \u265A ",
    bqueen: " \u265B ",
    brook: " \u265C ",
    bbishop: " \u265D ",
    bknight: " \u265E ",
    bpawn: " \u265F "
  }.freeze

  def display_grid(grid)
    grid.each do |x|
      tile = get_tile(x)
      tile = put_piece(x,tile) unless x.size == 2
      print tile.join("")
      print "\n" if line_break?(x)
    end
  end

  def get_tile(location)
    dark = ["\u001b[43m ","  \u001b[0m"]
    light = ["\u001b[45m ","  \u001b[0m"]
    if location[0].even?
      location[1].even? ? dark : light
    else
      location[1].even? ? light : dark
    end
  end

  def put_piece(lp,tile)
    tile.each {|x| x.strip!}
    piece = PCS[lp[2].to_sym]
    tile.insert(1,piece)
  end

  def line_break?(location)
    location[1] == 8
  end
end
