require 'rubygems'
require 'gosu'

class TrainingWheels < Gosu::Window
  def initialize
    super 800, 600, false
    @score  = 0
    @font   = Gosu::Font.new self, Gosu::default_font_name, 40
    @small_font   = Gosu::Font.new self, Gosu::default_font_name, 30
    @rocket = Gosu::Sample.new self, 'sounds/bottlerocket.wav'
    @ohno   = Gosu::Sample.new self, 'sounds/oh_no.wav'
    @word   = Word.new self
    @start = Time.now
    @second = @time = 15
  end

  def update
    elapsed = Time.now - @start
    @second = @time - elapsed.to_i
    wrong if @second == 0
  end

  def draw
    @word.draw
    @font.draw "Training Wheels!", 10, 10, 1.0, 1.0, 1.0, 0xffffff00
    instructions = "Press space when they get it right"
    @small_font.draw instructions, self.width-@small_font.text_width(instructions)-10,
      self.height-@small_font.height-10, 1.0, 1.0, 1.0, 0xffffff00
    @font.draw @score.to_s, 10, height - 40,  1.0, 1.0, 1.0, 0xffffff00
    @font.draw @second.to_s, self.width-@font.text_width(@second.to_s)-10, 10, 1.0, 1.0, 1.0, 0xffffff00
  end

  def button_down(id)
    case id
    when Gosu::Button::KbEscape
      close
    when Gosu::Button::KbRight
      wrong
    when Gosu::Button::KbSpace
      correct
    end
  end

  def wrong
    @start = Time.now
    @score = @score - 50
    @ohno.play
    @word.wrong
  end

  def correct
    @start = Time.now
    @rocket.play
    @score = @score + (10 * @second)
    @word.correct
  end
end

class Spark
end

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
  end

  def next
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

  def x
    @window.width/2 - @font.text_width(current)/2
  end

  def y
    @window.height/2 - @font.height/2
  end

  def color
    case @words[current]
    when 0: 0xffff0000
    when 1: 0xffffff00
    else    0xff00ff00
    end
  end

  def draw
    @font.draw self.current, self.x, self.y, 1.0, 1.0, 1.0, color
  end
end

window = TrainingWheels.new
window.show

