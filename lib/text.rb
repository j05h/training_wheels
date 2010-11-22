class Text
  attr_accessor :value, :font, :color, :vertical, :horizontal, :window
  attr_writer   :width

  def initialize window, val, font, v, h, color = 0xff000000
    self.window     = window
    self.value      = val
    self.font       = font
    self.color      = color
    self.vertical   = v
    self.horizontal = h
  end

  def vert
    (vertical == :top)  ? 10 : window.height - font.height - 5
  end

  def width
    @width ? @width : font.text_width(value)
  end

  def horizon
    (horizontal == :left) ? 10 : window.width - self.width - 10
  end

  def draw
    font.draw value, horizon, vert, 1.0, 1.0, 1.0, color
  end
end
