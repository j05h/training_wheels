class Text
  attr_accessor :value, :font, :color, :vertical, :horizontal, :window

  def initialize window, val, font, v, h, color = 0xffffff00
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

  def horizon
    (horizontal == :left) ? 10 : window.width - font.text_width(value) - 10
  end

  def draw
    font.draw value, horizon, vert, 1.0, 1.0, 1.0, color
  end
end
