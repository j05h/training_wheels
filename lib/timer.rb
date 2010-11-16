class Timer < Text
  attr_accessor :max, :start
  def initialize window, max, font
    super window, max, font, :top, :right
    self.max = max
    self.reset
  end

  def value
    max - (Time.now - self.start).to_i
  end

  def reset
    self.start = Time.now
  end
end
