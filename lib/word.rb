class Word
  attr_reader :current

  def initialize window
    @window = window
    @list = []
    @font = Gosu::Font.new window, Gosu::default_font_name, 80
    @words = {}
    word_list.each do |word|
      @words[word] = 0
    end
    self.next
  end

  def bad_list
    %w{an at do go he in like mom no of see she we}
  end

  def word_list
    %w{a am and baby can cat dad dog for I is it me my said so the to up you}
  end

  def next
    @played = false
    @current = @words.keys[rand(1000)%@words.keys.size]
    @list = []
    4.times do
      @list << bad_list[rand(1000)%bad_list.size]
    end
    @list[rand(4)%@list.size] = @current
  end

  def wrong
    count = @words[current] = @words[current] - 1 unless @words[current] == 0
    self.next
    return count
  end

  def correct
    count = @words[current] = @words[current] + 1
    self.next
    return count
  end

  def vert word, quadrant
    q = @window.width / 4
    if quadrant
      quad = (quadrant == 1 || quadrant == 3) ? q * 3 : q
    else
      quad = q * 2
    end
    quad - @font.text_width(word)/2
  end

  def horizon quadrant
    q = @window.height / 4
    if quadrant
      quad = (quadrant < 3) ? q : q * 3
    else
      quad = q * 2
    end
    quad - @font.height/2
  end

  def play
    file = "sounds/words/#{current}.wav"
    if File.exists?(file) && !@played
      @sample = Gosu::Sample.new(@window, file).play
    else
      false
    end
  end

  def color quad
    if within? @mouse_x, @mouse_y, quad
      0xff00ff00
    else
      0xffff0000
    end
  end

  def current_quadrant
    @list.each_index do |index|
      return index+1 if @current == @list[index]
    end
  end

  def within? other_x, other_y, quad = current_quadrant
    return false unless other_x && other_y && quad
    x = vert current, quad
    y = horizon quad

    other_x > x && other_x < (x + @font.text_width(@list[quad-1])) &&
    other_y > y && other_y < (y + @font.height)
  end

  def location x, y
    @mouse_x = x
    @mouse_y = y
  end

  def draw review = false
    if review
      @font.draw current, self.vert(current, nil), self.horizon(nil), 1.0, 1.0, 1.0, color(nil)
    else
      @list.each_index do |index|
        word = @list[index]
        quad = index + 1
        @font.draw word, self.vert(word, quad), self.horizon(quad), 1.0, 1.0, 1.0, color(quad)
      end
    end
  end
end

