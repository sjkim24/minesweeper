class Board

  def initialize
    @board = Array.new(9) { Array.new(9) }

  end

  def plant_bombs
    10.times do
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

end
