class Game
    def initialize
    end

    def play
        welcome
        if new_game? 
            create_board
            populate_board
            create_players
        else
            restore_game
        end

        display_board
        get_input
        update_board
        if checkmate?
            decide_winner
            announce_winner
            break
        elsif draw? 
          announce_draw
          break
        end 
        update_id 
    end
end