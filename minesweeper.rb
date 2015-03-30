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
    board[row][col]
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

  attr_accessor :game_board, :player

  def initialize(player)
    @game_board = Board.new
    @player = Player.new(player)
  end

  def run
    until false
      index_array = player.get_position

      game_over if check_position(index_array) == 1 && game_board[index_array].bomb

    end
  end

  def check_position(index_array)

    if game_board[index_array].reveal
      puts "This position is already revealed."
    elsif game_board[index_array].bomb
      return 1
    elsif game_board[index_array].reveal
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

  def render
    #byebug
    game_board.board.map do |array|
      array.map do |tile|
        if tile.reveal == false
          tile = :x
        elsif tile.flag
          tile = :f
        elsif tile.reveal && tile.bomb
          tile = :b
        else
          tile = :o
        end
      end.join(" ")
    end.join("\n")
  end

  def display
    puts render
  end

  def my_map(&prc)
    new_array = []
    self.each do |el|
      new_array << prc.call(el)
    end
    new_array
  end

end

game = Game.new('SJ')
#game.run
