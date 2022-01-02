class Player
  attr_reader :name, :color

  def initialize(name, color)
    @name = name
    @color = color
  end
end

class Human < Player
  def piece_select(_position)
    puts "Player #{@name}, Please enter a #{@color.capitalize} piece to select"
    gets.chomp
  end

  def move_select(_moves)
    puts "Player #{@name}, Please enter a square to make a move"
    gets.chomp
  end
end

class Bot < Player
  # aka the dumb bot!
  def array_to_alpha(ar)
    "#{('a'..'h').to_a[ar[1] - 1]}#{ar[0]}"
  end

  def piece_select(positions)
    positions.sample(1)[0]
  end

  def move_select(moves)
    move = moves.sample(1)[0]
    array_to_alpha(move)
  end
end
