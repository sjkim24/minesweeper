require 'byebug'

class Board

  attr_accessor :board, :bomb_indices, :board_size, :bomb_number

  def initialize(board_size, bomb_number)
    @board_size = board_size
    @bomb_number = bomb_number
    @board = Array.new(board_size) { Array.new(board_size) }
    @bomb_indices = []
    set_board_positions_to_tile_nodes
    plant_bombs
  end

  def [](pos)
    row, col = pos
    board[row][col]
  end

  def set_board_positions_to_tile_nodes
    @board.map! do |arr|
      arr.map! do |el|
        el = TileNode.new
      end
    end
  end

  def plant_bombs
    until bomb_indices.length == bomb_number
      col = rand(0...board_size)
      row = rand(0...board_size)
      pos = [row, col]

      unless bomb_indices.include?(pos)
        bomb_indices << pos
        board[pos[0]][pos[1]].bomb = true
      end
    end
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

  def get_action
    puts "F to place a flag, R to reveal a square."
    gets.chomp
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

  attr_accessor :game_board, :player, :reveal_counter, :board_size, :bomb_number

  def initialize(player, board_size, bomb_number)
    @board_size = board_size
    @bomb_number = bomb_number
    @game_board = Board.new(board_size, bomb_number)
    @player = Player.new(player)
    @reveal_counter = 0
  end

  def run
    until won?
      display

      index_array = player.get_position
      action = player.get_action

      check_input(index_array, action)
    end

    puts "Congrats, you found all the mines."
  end

  def check_input(index_array, action_input)
    if action_input.downcase == "f"
      flag = game_board[index_array].flag

      flag ? flag = false : flag = true
      run
    elsif action_input.downcase == "r"
      game_over? if check_position(index_array) == 1 && game_board[index_array].bomb
    else
      puts "Wrong input"
      run
    end
  end

  def won?
    reveal_counter == (board_size ** 2) - bomb_number
  end

  def game_over?
    puts "You lose"
    game_board.bomb_indices.each do |bombs|
      game_board[bombs].reveal = true
    end
    display
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

      @reveal_counter += 1
    end
  end

  def create_neighbors(index_array)
    neighbor_array = Array.new(8) { Array.new(2) }

    NEIGHBORS.each_with_index do |arr, idx|
      neighbor_array[idx] = [arr[0] + index_array[0], arr[1] + index_array[1]]
    end

    neighbor_array.select do |arr|
      arr.all? { |el| el >= 0 && el <= (game_board.board_size - 1) }
    end
  end

  def render
    game_board.board.map do |array|
      array.map do |tile|
        if tile.flag
          tile = :f
        elsif tile.reveal == false
          tile = :x
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

game = Game.new('SJ', 9, 10)
game.run
