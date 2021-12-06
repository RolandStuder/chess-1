module Display 
    def welcome 
        puts "Welcome to Chess!"
        puts "A game made in ruby. Hope you enjoy"
        puts "Goodluck!"
    end

    def new_game?
        puts "Press 1 for a new game"
        puts "Press 2 to load a previous game"
        input = gets.chomp.to_i
        until input.between?(1,2)
            puts = "You have entered an invalid number, try again"
            input = gets.chomp.to_i
        end
        input == 1
    end

    def display_board
    end

    def get_input
    end

    def announce_winner
    end

    def announce_draw
    end
end