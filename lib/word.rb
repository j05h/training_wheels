class Word
  attr_reader :current

  def initialize window
    @window = window
    @font = Gosu::Font.new window, Gosu::default_font_name, 80
    @words = {}
    word_list.each do |word|
      @words[word] = 0
    end
    self.next
  end

  def word_list
    %w{and to it for a up so dad the said dog I am cat my can you an go in is of like do see he she me mom no we at}
    %w{and baby is it me the to}
  end

  def next
    @played = false
    @current = @words.keys[rand(1000)%@words.keys.size]
  end

  def wrong
    count = @words[current] = @words[current] - 1 unless @words[current] == 0
    self.next
    return count
  end

  def correct
    count = @words[current] = @words[current] + 1
    puts "You know #{current} (#{@words.delete(current)})" if @words[current] > 2
    self.next
    return count
  end

  def vert
    @window.width/2 - @font.text_width(current)/2
  end

  def horizon
    @window.height/2 - @font.height/2
  end

  def play
    file = "sounds/words/#{current}.wav"
    if File.exists?(file) && !@played
      @sample = Gosu::Sample.new(@window, file).play
    else
      false
    end
  end

  def color
    case @words[current]
    when 0: 0xffff0000
    when 1: 0xffffff00
    else    0xff00ff00
    end
  end

  def draw
    @font.draw self.current, self.vert, self.horizon, 1.0, 1.0, 1.0, color
  end
end

