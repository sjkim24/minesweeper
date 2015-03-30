class Board

end

class TileNode

  attr_reader :parent

  def initialize(value = 0)
    @children = []
    @parent = nil
    @value = value
  end

  def parent=(parent)
   return if self.parent == parent

   if self.parent
     self.parent._children.delete(self)
   end

   @parent = parent
   self.parent._children << self unless self.parent.nil?

   self
 end

 def add_child(child)
   child.parent = self
 end

 def remove_child(child)
   if child && !self.children.include?(child)
     raise "Tried to remove node that isn't a child"
   end

   child.parent = nil
 end

 protected
 def _children
   @children
 end
end


class Game

end
