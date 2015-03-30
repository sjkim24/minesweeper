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

  attr_accessor :reveal, :bomb, :flag, :value

  def initialize
    @reveal = false
    @bomb = false
    @flag = false
    @value = 0
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

  attr_accessor :game_board, :player, :reveal_counter

  def initialize(player)
    @game_board = Board.new
    @player = Player.new(player)
    @reveal_counter = 0
  end

  def run
    until false
      index_array = player.get_position

      game_over? if check_position(index_array) == 1 && game_board[index_array].bomb
      display
    end
  end

  def win?
    game_board.count

  end

  def game_over?
    puts "You lose"
  end

  def check_position(index_array)
    bomb_counter = 0

    if game_board[index_array].reveal
      return 0
    elsif game_board[index_array].bomb
      return 1
    elsif game_board[index_array].reveal == false
      neighbors = create_neighbors(index_array)

      neighbors.each do |neighbor|
        bomb_counter += 1 if game_board[neighbor].bomb
      end

      if bomb_counter > 0
        game_board[index_array].reveal = true
        game_board[index_array].value = bomb_counter
        return bomb_counter
      else
        game_board[index_array].reveal = true
        neighbors.each { |neighbor| check_position(neighbor) }
      end
    end
  end

  def create_neighbors(index_array)
    neighbor_array = Array.new(8) { Array.new(2) }

    NEIGHBORS.each_with_index do |arr, idx|
      neighbor_array[idx] = [arr[0] + index_array[0], arr[1] + index_array[1]]
    end

    neighbor_array.select do |arr|
      arr.all? { |el| el >= 0 && el <= 8 }
    end
  end

  def render
    game_board.board.map do |array|
      array.map do |tile|
        if tile.reveal == false
          tile = :x
        elsif tile.flag
          tile = :f
        elsif tile.reveal && tile.bomb
          tile = :b
        elsif tile.value > 0
          tile = tile.value
        else
          tile = :o
        end
      end.join(" ")
    end.join("\n")
  end

  def display
    puts render
  end

end

game = Game.new('SJ')
#game.run
