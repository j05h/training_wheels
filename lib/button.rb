class Button < Gosu::Image
  attr_accessor :x, :y
  def initialize window, image
    super window, image, true
  end

  def draw x, y
    super x, y, 1
    self.x = x
    self.y = y
  end

  def within other_x, other_y
    other_x > x && other_x < (x + self.width) &&
    other_y > y && other_y < (y + self.height)
  end
end

