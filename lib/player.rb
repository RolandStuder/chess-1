class Player
  attr_reader :name, :color

  def initialize(name, color)
    @name = name
    @color = color
  end
end

class Human < Player
  def piece_select
    puts "Player #{@name}, Please enter a #{@color.capitalize} piece to select"
    gets.chomp
  end

  def move_select
    puts "Player #{@name}, Please enter a square to make a move"
    gets.chomp
  end
end

class Bot < Player
  # aka the dumb bot!
  def rand_select
    rand1 = ('a'..'h').to_a.sample(1)[0]
    rand2 = rand(1..8)
    "#{rand1}#{rand2}"
  end

  def piece_select
    rand_select
  end

  def move_select
    rand_select
  end
end
