require 'byebug'

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

  def [](pos)
    row, col = pos
    booard[row][col]
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

class Player

  attr_reader :name

  def initialize(name)
    @name = name
  end

  def get_position
    puts "What position would you like to choose? Please put space between indices."
    index_input = gets.chomp.split(" ")
    index_input.map! { |index| index.to_i }
  end

end

class Game

  NEIGHBORS = [
    [-1, -1],
    [-1, 0],
    [-1, 1],
    [0, -1],
    [0, 1],
    [1, -1],
    [1, 0],
    [1, 1]
  ]

  attr_accessor :game_board, :master_board, :player

  def initialize(player)
    @game_board = Array.new(9) { Array.new(9) }
    @master_board = Board.new.board
    @player = Player.new(player)
  end

  def run
    until false
      index_array = player.get_position

      game_over if check_position(index_array) == 1 && master_board[row][col].bomb == true

      merge_boards
      display
    end
  end

  def check_position(index_array)
    row, col = index_array

    if master_board[row][col].reveal == true
      puts "This position is already revealed."
    elsif master_board[row][col].bomb == true
      return 1
    elsif master_board[row][col].reveal == false && neighbor has bomb

      return bomb_count

    elsif
      master_board[row][col].reveal = true
      neighbors = create_neighbors(row, col)

      neighbors.each do |neighbor|
        check_position(neighbor)
      end
    end
  end

  def create_neighbors(row, col)
    neighbor_array = Array.new(8) { Array.new(2) }

    NEIGHBORS.each_with_index do |arr, idx|
      neighbor_array[idx] = [arr[0] + row, arr[1] + col]
    end

    neighbor_array.select do |arr|
      arr.all? { |el| el >= 0 && el <= 8 }
    end
  end

  def display
    game_board.each do |array|
      puts array
    end
  end

  def merge_boards
    game_board.each_with_index do |array, idx1|
      array.each_with_index do |node, idx2|
        if master_board[idx1][idx2].reveal == true && master_board[idx1][idx2].bomb == true
          game_board[idx1][idx2] = :b
        elsif master_board[idx1][idx2].reveal == true
          game_board[idx1][idx2] = :o
        elsif master_board[idx1][idx2].flag == true && master_board[idx1][idx2].reveal == false
          game_board[idx1][idx2] = :f
        elsif master_board[idx1][idx2].reveal == false
          game_board[idx1][idx2] = :x
        end
      end
    end
  end
end
  #   For better visual display, mess with visual indices
  #
  #   game_board.each_with_index do |array, idx|
  #     array[0] = (idx).to_s
  #   end
  #
  #   game_board[0].each_with_index do |el, idx|
  #     game_board[-1][idx] = (idx + 1).to_s
  #   end

game = Game.new('SJ')
#game.run
