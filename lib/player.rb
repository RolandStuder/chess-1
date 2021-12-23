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
end
