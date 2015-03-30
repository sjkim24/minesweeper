class Board

  attr_accessor :board

  def initialize
    @board = Array.new(9) { Array.new(9) }
    set_board_positions_to_tile_nodes
    plant_bombs
  end

  def set_board_positions_to_tile_nodes
    @board.map! do |arr|
      arr.map! do |el|
        el = TileNode.new
      end
    end
  end

  def plant_bombs
    bomb_indices = []

    until bomb_indices.length == 10
      col = rand(0..8)
      row = rand(0..8)
      pos = [row, col]

      bomb_indices << pos unless bomb_indices.include?(pos)

      @board[col][row].bomb = true
    end

  end

end

class TileNode

  attr_accessor :reveal, :bomb, :flag

  def initialize
    @reveal = false
    @bomb = false
    @flag = false
  end


end


class Game

  attr_accessor :game_board, :master_board

  def initialize
    @game_board = Array.new(9) { Array.new(9) }
    @master_board = Board.new.board
  end

  def display
    @game_board.each_with_index do |array, idx1|
      array.each_with_index do |node, idx2|
        if master_board[idx1][idx2].reveal == true && master_board[idx1][idx2].bomb == true
          game_board[idx1][idx2] = :b
        elsif master_board[idx1][idx2].reveal == true
          ngame_board[idx1][idx2] = :o
        elsif master_board[idx1][idx2].flag == true && master_board[idx1][idx2].reveal == false
          game_board[idx1][idx2] = :f
        elsif master_board[idx1][idx2].reveal == false
          game_board[idx1][idx2] = :x
        end
      end
    end
  end

end
